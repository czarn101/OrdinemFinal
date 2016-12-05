package com.Ordinem;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
//import java.awt.event.ActionEvent;
//import java.awt.event.ActionListener;

/**
 * Created by Albert on 12/4/2016.
 */
public class LoginPortal {
    private JPanel loginPage;
    private JPasswordField enterPasswordPasswordField;
    private JTextField textField1;
    private JButton button1;

    public LoginPortal() {

        button1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null,"hello");
            }
        });

        loginPage.setBackground(Color.green);


    }

    private void createUIComponents() {
        // TODO: place custom component creation code here


    }

    public static void main(String[] args) {

        //logPortal.loginPage.setBackground(Color.green);
        JFrame frame = new JFrame("LoginPortal");
        LoginPortal logPortal = new LoginPortal();
        logPortal.textField1
        frame.setSize(810,510);


        frame.setContentPane(new LoginPortal().loginPage);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        frame.setVisible(true);

}
}
