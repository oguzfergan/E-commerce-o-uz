import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

public class AdminDashboard extends JFrame {
    private JTabbedPane tabbedPane;
    private JTable tableUsers, tableShipments;
    private DefaultTableModel modelUsers, modelShipments;

    public AdminDashboard(int adminId) {
        setTitle("Admin Dashboard");
        setSize(900, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        tabbedPane = new JTabbedPane();
        tabbedPane.addTab("Manage Users", createUserPanel());
        tabbedPane.addTab("Manage Shipments", createShipmentPanel());

        add(tabbedPane);
        
        tabbedPane.addChangeListener(e -> {
            if (tabbedPane.getSelectedIndex() == 0) loadUsers();
            else loadShipments();
        });
        
        loadUsers();
    }

    // --- user managment --- \\
    private JPanel createUserPanel() {
        JPanel panel = new JPanel(new BorderLayout());
        String[] cols = {"ID", "Username", "Role", "Email"};
        modelUsers = new DefaultTableModel(cols, 0);
        tableUsers = new JTable(modelUsers);
        panel.add(new JScrollPane(tableUsers), BorderLayout.CENTER);
        
        JButton btnDelete = new JButton("Delete Selected User");
        panel.add(btnDelete, BorderLayout.SOUTH);
        
        btnDelete.addActionListener(e -> {
            int row = tableUsers.getSelectedRow();
            if (row == -1) return;
            int uId = (int) modelUsers.getValueAt(row, 0);
            
            int confirm = JOptionPane.showConfirmDialog(this, "Are you sure? This will delete ALL related data (Orders, Products)!");
            if (confirm == JOptionPane.YES_OPTION) {
                try (Connection conn = DbHelper.getConnection()) {
                    PreparedStatement pst = conn.prepareStatement("DELETE FROM Users WHERE UserID = ?");
                    pst.setInt(1, uId);
                    pst.executeUpdate();
                    loadUsers();
                } catch (SQLException ex) { JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage()); }
            }
        });
        
        return panel;
    }

    private void loadUsers() {
        modelUsers.setRowCount(0);
        try (Connection conn = DbHelper.getConnection()) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT UserID, Username, Role, Email FROM Users");
            while(rs.next()) {
                modelUsers.addRow(new Object[]{
                    rs.getInt("UserID"), rs.getString("Username"), rs.getString("Role"), rs.getString("Email")
                });
            }
        } catch (SQLException ex) { ex.printStackTrace(); }
    }

    // --- CARGO MANAGMENT --- \\
    private JPanel createShipmentPanel() {
        JPanel panel = new JPanel(new BorderLayout());
        String[] cols = {"OrderID", "Status", "Payment Status"};
        modelShipments = new DefaultTableModel(cols, 0);
        tableShipments = new JTable(modelShipments);
        panel.add(new JScrollPane(tableShipments), BorderLayout.CENTER);
        
        JPanel btnPanel = new JPanel();
        JButton btnCreateShip = new JButton("Create Shipment (For Confirmed)");
        JButton btnUpdateStatus = new JButton("Update Status (To Delivered)");
        
        btnPanel.add(btnCreateShip);
        btnPanel.add(btnUpdateStatus);
        panel.add(btnPanel, BorderLayout.SOUTH);
        
        btnCreateShip.addActionListener(e -> createShipmentAction());
        
        btnUpdateStatus.addActionListener(e -> updateShipmentStatus());
        
        return panel;
    }

    private void loadShipments() {
        modelShipments.setRowCount(0);
        try (Connection conn = DbHelper.getConnection()) {
            String sql = "SELECT o.OrderID, o.OrderStatus, p.PaymentStatus " +
                         "FROM Orders o LEFT JOIN Payments p ON o.OrderID = p.OrderID";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()) {
                modelShipments.addRow(new Object[]{
                    rs.getInt("OrderID"), rs.getString("OrderStatus"), rs.getString("PaymentStatus")
                });
            }
        } catch (SQLException ex) { ex.printStackTrace(); }
    }
    
    private void createShipmentAction() {
        int row = tableShipments.getSelectedRow();
        if (row == -1) return;
        
        int orderId = (int) modelShipments.getValueAt(row, 0);
        String orderStatus = (String) modelShipments.getValueAt(row, 1);
        String payStatus = (String) modelShipments.getValueAt(row, 2);
        
        // Gereksinim: Sadece ödemesi bitmiş ve satıcı onaylamışsa kargo başlar
        if (!"Confirmed".equals(orderStatus) || !"Completed".equals(payStatus)) {
            JOptionPane.showMessageDialog(this, "Order must be Confirmed and Paid to start shipment.");
            return;
        }
        
        try (Connection conn = DbHelper.getConnection()) {
            // Prosedür: sp_CreateShipment
            CallableStatement cstmt = conn.prepareCall("{call sp_CreateShipment(?, ?, ?)}");
            cstmt.setInt(1, orderId);
            cstmt.setString(2, "TRK-" + System.currentTimeMillis());
            cstmt.setString(3, "PTT Cargo");
            cstmt.execute();
            loadShipments();
            JOptionPane.showMessageDialog(this, "Shipment Created! Order is now Processing.");
        } catch (SQLException ex) { 
             JOptionPane.showMessageDialog(this, "Error (Maybe shipment already exists): " + ex.getMessage()); 
        }
    }
    
    private void updateShipmentStatus() {
         int row = tableShipments.getSelectedRow();
         if (row == -1) return;
         int orderId = (int) modelShipments.getValueAt(row, 0);
         
         // Shipment ID 
         try (Connection conn = DbHelper.getConnection()) {
             String sql = "SELECT ShipmentID FROM Shipments WHERE OrderID = ?";
             PreparedStatement pst = conn.prepareStatement(sql);
             pst.setInt(1, orderId);
             ResultSet rs = pst.executeQuery();
             
             if(rs.next()) {
                 int shipId = rs.getInt(1);
                 // Prosedür: sp_UpdateShipmentStatus
                 CallableStatement cstmt = conn.prepareCall("{call sp_UpdateShipmentStatus(?, ?)}");
                 cstmt.setInt(1, shipId);
                 cstmt.setString(2, "Delivered"); // Demo için direkt teslim edildi yapıyoruz
                 cstmt.execute();
                 loadShipments();
                 JOptionPane.showMessageDialog(this, "Status Updated to Delivered!");
             } else {
                 JOptionPane.showMessageDialog(this, "No shipment record found for this order.");
             }
         } catch (SQLException ex) { ex.printStackTrace(); }
    }
}