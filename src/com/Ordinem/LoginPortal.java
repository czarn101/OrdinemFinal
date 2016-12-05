package com.Ordinem;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Albert on 12/4/2016.
 */
public class LoginPortal {
    private JPanel loginPage;
    private JPasswordField passwordField1;
    private JTextField textField1;
    private JButton button1;

    public LoginPortal() {
        button1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null,"hello");
            }
        });
    }

    private void createUIComponents() {
        // TODO: place custom component creation code here


    }

    public static void main(String[] args) {
        JFrame frame = new JFrame("LoginPortal");
        frame.setContentPane(new LoginPortal().loginPage);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
    }
}
