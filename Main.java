import javax.swing.*;
import java.awt.*;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt; // Projene jBCrypt kütüphanesini eklemelisin!

public class Main extends JFrame {

    private JTextField txtUsername;
    private JPasswordField txtPassword;

    public Main() {
        setTitle("E-Commerce System Giriş");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null); 
        setLayout(new GridLayout(4, 1, 10, 10));

        JLabel lblTitle = new JLabel("E-Ticaret Sistemine Hoşgeldiniz", SwingConstants.CENTER);
        lblTitle.setFont(new Font("Arial", Font.BOLD, 18));
        add(lblTitle);

        JPanel panelInput = new JPanel(new GridLayout(2, 2, 5, 5));
        
        panelInput.add(new JLabel("  Kullanıcı Adı:"));
        txtUsername = new JTextField("customer_alice"); 
        panelInput.add(txtUsername);
        
        panelInput.add(new JLabel("  Şifre:"));
        txtPassword = new JPasswordField("12345"); 
        panelInput.add(txtPassword);
        
        add(panelInput);

        JPanel panelButtons = new JPanel(new FlowLayout());
        JButton btnLogin = new JButton("Giriş Yap (Login)");
        JButton btnRegister = new JButton("Kayıt Ol (Register)");
        
        panelButtons.add(btnLogin);
        panelButtons.add(btnRegister);
        add(panelButtons);

        JLabel lblStatus = new JLabel("Lütfen giriş yapınız...", SwingConstants.CENTER);
        add(lblStatus);

        btnLogin.addActionListener(e -> {
            String user = txtUsername.getText();
            String pass = new String(txtPassword.getPassword());
            performLogin(user, pass);
        });

        btnRegister.addActionListener(e -> {
            new RegisterFrame().setVisible(true);
        });
    }

    private void performLogin(String username, String password) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            
            String sql = "SELECT * FROM Users WHERE Username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbHash = rs.getString("PasswordHash");
                
                // BCrypt ile şifre doğrulama
                // Eğer jBCrypt kütüphanen yoksa burası hata verir. 
                // Geçici çözüm (güvensiz) için: if(password.equals("12345")) ... yapabilirsin.
                if (BCrypt.checkpw(password, dbHash)) {
                    
                    int id = rs.getInt("UserID");
                    String role = rs.getString("Role");
                    String fullName = rs.getString("FirstName") + " " + rs.getString("LastName");
                    

                    User currentUser = new User(id, username, role, fullName);

                    JOptionPane.showMessageDialog(this, "Giriş Başarılı! Hoşgeldin: " + fullName);
                    
                    if (role.equalsIgnoreCase("Customer")) {
                        new CustomerDashboard(currentUser).setVisible(true);
                    } else if (role.equalsIgnoreCase("Seller")) {
                        new SellerDashboard(currentUser).setVisible(true);
                    } else if (role.equalsIgnoreCase("Administrator")) {
                        new AdminDashboard(currentUser).setVisible(true);
                    } else {
                        JOptionPane.showMessageDialog(this, "Hata: Tanımsız Rol -> " + role);
                    }
                    
                    dispose(); 

                } else {
                    JOptionPane.showMessageDialog(this, "Hatalı Şifre!");
                }
            } else {
                JOptionPane.showMessageDialog(this, "Kullanıcı Bulunamadı!");
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(this, "Veritabanı Bağlantı Hatası: " + ex.getMessage());
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new Main().setVisible(true);
        });
    }
}