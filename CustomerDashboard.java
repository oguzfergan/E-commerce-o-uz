import java.awt.*;
import java.sql.*;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;

public class CustomerDashboard extends JFrame {
    private User currentUser; // User nesnesi
    private JTabbedPane tabbedPane;
    private JTable tableProducts, tableCart, tableHistory;
    private DefaultTableModel modelProducts, modelCart, modelHistory;
    private JLabel lblCartTotal;
    private JTextField txtCouponCode;

    public CustomerDashboard(User user) {
        this.currentUser = user;
        setTitle("Customer Dashboard - " + user.getFullName());
        setSize(1000, 700);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        tabbedPane = new JTabbedPane();

        tabbedPane.addTab("Products & Catalog", createProductsPanel());
        tabbedPane.addTab("My Cart & Checkout", createCartPanel());
        tabbedPane.addTab("Order History", createHistoryPanel());
        tabbedPane.addTab("My Statistics", createStatsPanel());

        add(tabbedPane);

        tabbedPane.addChangeListener(e -> {
            int index = tabbedPane.getSelectedIndex();
            if (index == 0) loadProducts();
            else if (index == 1) loadCart();
            else if (index == 2) loadOrderHistory();
            else if (index == 3) updateStats((JPanel) tabbedPane.getComponentAt(3));
        });

        loadProducts();
    }

    private JPanel createProductsPanel() {
        JPanel panel = new JPanel(new BorderLayout());
    
        String[] columns = {"ID", "Product Name", "Category", "Price", "Stock", "Seller"};
        modelProducts = new DefaultTableModel(columns, 0) {
            @Override public boolean isCellEditable(int row, int col) { return false; }
        };
        tableProducts = new JTable(modelProducts);
        // ID kolonunu gizle
        tableProducts.getColumnModel().getColumn(0).setMinWidth(0);
        tableProducts.getColumnModel().getColumn(0).setMaxWidth(0);
        tableProducts.getColumnModel().getColumn(0).setWidth(0);
        
        panel.add(new JScrollPane(tableProducts), BorderLayout.CENTER);

        JPanel btnPanel = new JPanel();
        JButton btnAdd = new JButton("Add to Cart");
        JButton btnRefresh = new JButton("Refresh List");
        
        btnRefresh.addActionListener(e -> loadProducts());
        btnAdd.addActionListener(e -> addToCartAction());
        
        btnPanel.add(btnRefresh);
        btnPanel.add(btnAdd);
        panel.add(btnPanel, BorderLayout.SOUTH);
        
        return panel;
    }

    private void loadProducts() {
        modelProducts.setRowCount(0);
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT * FROM vw_SellerProductCatalog WHERE IsActive = TRUE AND StockQuantity > 0";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()) {
                modelProducts.addRow(new Object[]{
                    rs.getInt("ProductID"),
                    rs.getString("ProductName"),
                    rs.getString("CategoryName"),
                    rs.getBigDecimal("Price"),
                    rs.getInt("StockQuantity"),
                    rs.getString("SellerName")
                });
            }
        } catch (SQLException ex) { ex.printStackTrace(); }
    }

    // --- KRİTİK DEĞİŞİKLİK: Çoklu Satıcı Desteği ile Sepete Ekleme ---
    private void addToCartAction() {
        int row = tableProducts.getSelectedRow();
        if (row == -1) {
            JOptionPane.showMessageDialog(this, "Select a product first.");
            return;
        }
        
        int productId = (int) modelProducts.getValueAt(row, 0);
        String qtyStr = JOptionPane.showInputDialog(this, "Enter Quantity:");
        if (qtyStr == null) return;
        
        try {
            int quantity = Integer.parseInt(qtyStr);
            if (quantity <= 0) throw new NumberFormatException();
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                
                // 1. Ürünün Satıcısını Bul
                int sellerId = getSellerId(conn, productId);
                
                // 2. Bu müşteri için, BU SATICIYA ait açık (Pending) sipariş var mı?
                int orderId = getPendingOrderIdForSeller(conn, currentUser.getId(), sellerId);
                
                if (orderId != -1) {
                    // Varsa mevcut siparişe ekle
                    addItemToOrder(conn, orderId, productId, quantity);
                } else {
                    // Yoksa, bu satıcı için YENİ sipariş oluştur
                    int demoAddressId = 1; // Gerçek uygulamada kullanıcı seçmeli
                    createOrderAndAddItem(conn, currentUser.getId(), sellerId, demoAddressId, productId, quantity);
                }
                
                JOptionPane.showMessageDialog(this, "Added to cart!");
            }
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(this, "Invalid quantity.");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: " + e.getMessage());
        }
    }

    private int getSellerId(Connection conn, int productId) throws SQLException {
        String sql = "SELECT c.SellerID FROM Products p JOIN Catalogs c ON p.CatalogID = c.CatalogID WHERE p.ProductID = ?";
        PreparedStatement pst = conn.prepareStatement(sql);
        pst.setInt(1, productId);
        ResultSet rs = pst.executeQuery();
        return rs.next() ? rs.getInt(1) : -1;
    }

    // YENİ: Belirli bir satıcı için açık sipariş var mı?
    private int getPendingOrderIdForSeller(Connection conn, int userId, int sellerId) throws SQLException {
        String sql = "SELECT OrderID FROM Orders WHERE CustomerID = ? AND SellerID = ? AND OrderStatus = 'Pending'";
        PreparedStatement pst = conn.prepareStatement(sql);
        pst.setInt(1, userId);
        pst.setInt(2, sellerId);
        ResultSet rs = pst.executeQuery();
        return rs.next() ? rs.getInt("OrderID") : -1;
    }

    private void addItemToOrder(Connection conn, int orderId, int productId, int quantity) throws SQLException {
        CallableStatement cstmtItem = conn.prepareCall("{call sp_AddOrderItem(?, ?, ?)}");
        cstmtItem.setInt(1, orderId);
        cstmtItem.setInt(2, productId);
        cstmtItem.setInt(3, quantity);
        cstmtItem.execute();
    }

    private void createOrderAndAddItem(Connection conn, int userId, int sellerId, int addressId, int productId, int qty) throws SQLException {
        CallableStatement cstmt = conn.prepareCall("{call sp_PlaceOrder(?, ?, ?, ?, ?)}");
        cstmt.setInt(1, userId);
        cstmt.setInt(2, sellerId);
        cstmt.setInt(3, addressId);
        cstmt.setInt(4, addressId);
        cstmt.registerOutParameter(5, Types.INTEGER);
        cstmt.execute();
        int newOrderId = cstmt.getInt(5);
        
        addItemToOrder(conn, newOrderId, productId, qty);
    }
    // -----------------------------------------------------------------

    private JPanel createCartPanel() {
        JPanel panel = new JPanel(new BorderLayout());
        
        String[] columns = {"Product (Seller)", "Quantity", "Unit Price", "Subtotal"};
        modelCart = new DefaultTableModel(columns, 0);
        tableCart = new JTable(modelCart);
        panel.add(new JScrollPane(tableCart), BorderLayout.CENTER);
        
        JPanel bottomPanel = new JPanel(new GridLayout(3, 1));
        
        JPanel pnlCoupon = new JPanel(new FlowLayout(FlowLayout.LEFT));
        pnlCoupon.add(new JLabel("Coupon Code:"));
        txtCouponCode = new JTextField(10);
        pnlCoupon.add(txtCouponCode);
        JButton btnApply = new JButton("Apply Coupon");
        pnlCoupon.add(btnApply);
        
        lblCartTotal = new JLabel("Total: 0.00");
        lblCartTotal.setFont(new Font("Arial", Font.BOLD, 14));
        
        JButton btnPay = new JButton("Checkout / Pay All Pending Orders");
        
        bottomPanel.add(pnlCoupon);
        bottomPanel.add(lblCartTotal);
        bottomPanel.add(btnPay);
        panel.add(bottomPanel, BorderLayout.SOUTH);
        
        btnApply.addActionListener(e -> applyCouponAction());
        btnPay.addActionListener(e -> payAction());
        
        return panel;
    }

    private void loadCart() {
        modelCart.setRowCount(0);
        lblCartTotal.setText("Total: 0.00");
        double grandTotal = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Tüm Pending siparişlerin içeriğini çek (Farklı satıcılardan olabilir)
            String sql = "SELECT p.ProductName, oi.Quantity, oi.UnitPrice, oi.Subtotal, u.FirstName as SellerName " +
                         "FROM OrderItems oi " +
                         "JOIN Products p ON oi.ProductID = p.ProductID " +
                         "JOIN Orders o ON oi.OrderID = o.OrderID " +
                         "JOIN Users u ON o.SellerID = u.UserID " +
                         "WHERE o.CustomerID = ? AND o.OrderStatus = 'Pending'";
                         
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, currentUser.getId());
            ResultSet rs = pst.executeQuery();
            
            while(rs.next()) {
                modelCart.addRow(new Object[]{
                    rs.getString("ProductName") + " (" + rs.getString("SellerName") + ")", 
                    rs.getInt("Quantity"), 
                    rs.getDouble("UnitPrice"), 
                    rs.getDouble("Subtotal")
                });
                grandTotal += rs.getDouble("Subtotal");
            }
            
            lblCartTotal.setText(String.format("Cart Total: %.2f TL", grandTotal));
            
        } catch (SQLException ex) { ex.printStackTrace(); }
    }

    private void applyCouponAction() {
        // Not: Kupon mantığı her siparişe ayrı uygulanmalı, demo için ilk bulduğu siparişe uyguluyor
        try (Connection conn = DatabaseConnection.getConnection()) {
            int orderId = getFirstPendingOrderId(conn);
            if (orderId == -1) { JOptionPane.showMessageDialog(this, "Empty Cart"); return; }
            
            CallableStatement cstmt = conn.prepareCall("{call sp_ApplyCoupon(?, ?, ?, ?, ?)}");
            cstmt.setInt(1, orderId);
            cstmt.setString(2, txtCouponCode.getText().trim());
            cstmt.registerOutParameter(3, Types.BOOLEAN);
            cstmt.registerOutParameter(4, Types.VARCHAR);
            cstmt.registerOutParameter(5, Types.DECIMAL);
            cstmt.execute();
            
            JOptionPane.showMessageDialog(this, cstmt.getString(4));
            if (cstmt.getBoolean(3)) loadCart();
            
        } catch (SQLException ex) { ex.printStackTrace(); }
    }

    private void payAction() {
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Ödeme işlemi demo için basitleştirildi: İlk bulunan açık siparişi öder.
            // Gerçekte tüm pending siparişleri döngüyle ödemek gerekebilir.
            int orderId = getFirstPendingOrderId(conn);
            if (orderId == -1) {
                JOptionPane.showMessageDialog(this, "No pending orders found.");
                return;
            }
            
            String sqlT = "SELECT TotalAmount FROM Orders WHERE OrderID = ?";
            PreparedStatement pst = conn.prepareStatement(sqlT);
            pst.setInt(1, orderId);
            ResultSet rs = pst.executeQuery();
            double amount = 0;
            if (rs.next()) amount = rs.getDouble(1);
            
            CallableStatement cstmt = conn.prepareCall("{call sp_ProcessPayment(?, ?, ?, ?)}");
            cstmt.setInt(1, orderId);
            cstmt.setString(2, "Credit Card");
            cstmt.setDouble(3, amount);
            cstmt.setString(4, "TXN-" + System.currentTimeMillis());
            cstmt.execute();
            
            JOptionPane.showMessageDialog(this, "Payment Successful for Order #" + orderId);
            loadCart(); // Ödenen sipariş listeden kalkar (Status Confirmed olur)
            
        } catch (SQLException ex) { JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage()); }
    }

    private int getFirstPendingOrderId(Connection conn) throws SQLException {
        String sql = "SELECT OrderID FROM Orders WHERE CustomerID = ? AND OrderStatus = 'Pending' LIMIT 1";
        PreparedStatement pst = conn.prepareStatement(sql);
        pst.setInt(1, currentUser.getId());
        ResultSet rs = pst.executeQuery();
        return rs.next() ? rs.getInt(1) : -1;
    }

    private JPanel createHistoryPanel() {
        JPanel panel = new JPanel(new BorderLayout());
        modelHistory = new DefaultTableModel(new String[]{"Order ID", "Date", "Total", "Status"}, 0);
        tableHistory = new JTable(modelHistory);
        panel.add(new JScrollPane(tableHistory), BorderLayout.CENTER);
        return panel;
    }
    
    private void loadOrderHistory() {
        modelHistory.setRowCount(0);
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT OrderID, OrderDate, TotalAmount, OrderStatus FROM Orders WHERE CustomerID = ? ORDER BY OrderDate DESC";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, currentUser.getId());
            ResultSet rs = pst.executeQuery();
            while(rs.next()) {
                modelHistory.addRow(new Object[]{
                    rs.getInt("OrderID"), rs.getTimestamp("OrderDate"), rs.getDouble("TotalAmount"), rs.getString("OrderStatus")
                });
            }
        } catch (SQLException ex) { ex.printStackTrace(); }
    }

    private JPanel createStatsPanel() {
        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        return panel;
    }
    
    private void updateStats(JPanel panel) {
        panel.removeAll();
        panel.add(new JLabel("=== My Statistics (SQL Calculated) ==="));
        panel.add(Box.createVerticalStrut(20));
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql1 = "SELECT DATE_FORMAT(OrderDate, '%Y-%m') as M, SUM(TotalAmount) as T FROM Orders WHERE CustomerID = ? GROUP BY M";
            PreparedStatement pst1 = conn.prepareStatement(sql1);
            pst1.setInt(1, currentUser.getId());
            ResultSet rs1 = pst1.executeQuery();
            panel.add(new JLabel("Monthly Spending:"));
            while(rs1.next()) panel.add(new JLabel(rs1.getString("M") + ": " + rs1.getDouble("T") + " TL"));
            
            panel.add(Box.createVerticalStrut(20));
            
            String sql2 = "SELECT c.CategoryName, COUNT(*) as Cnt FROM OrderItems oi " +
                          "JOIN Products p ON oi.ProductID = p.ProductID JOIN Categories c ON p.CategoryID = c.CategoryID " +
                          "JOIN Orders o ON oi.OrderID = o.OrderID WHERE o.CustomerID = ? " +
                          "GROUP BY c.CategoryName ORDER BY Cnt DESC LIMIT 1";
            PreparedStatement pst2 = conn.prepareStatement(sql2);
            pst2.setInt(1, currentUser.getId());
            ResultSet rs2 = pst2.executeQuery();
            if(rs2.next()) panel.add(new JLabel("Favorite Category: " + rs2.getString(1) + " (" + rs2.getInt(2) + " items)"));
            
        } catch (SQLException ex) { ex.printStackTrace(); }
        panel.revalidate();
        panel.repaint();
    }
}