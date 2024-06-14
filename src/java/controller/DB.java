/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author talai
 */
import com.mysql.jdbc.Connection;
import java.sql.DriverManager;

public class DB {
    public static Connection getConnection() {
    Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/coffeeweb";
            String username = "root";  // Replace with your MySQL username
            String password = "";  // Replace with your MySQL password
            con = (Connection) DriverManager.getConnection(url, username, password);
            System.out.println("Connected Successfully");
        } catch (Exception e) {
            System.out.println("Database Not Connected");
        }
        return con;
    }
}
