import java.io.File;
import java.io.FileNotFoundException;
import java.sql.*;
import java.util.Scanner;

public class MyAuction {
	private Connection connection; //used to hold the jdbc connection to the DB
	private Statement statement; //used to create an instance of the connection
	private ResultSet resultSet; //used to hold the result of your query (if one // exists)
	private String query;  //this will hold the query we are using
	private String username, password;

	public MyAuction() {
		try {
			// get username and password
			Scanner scanner = new Scanner(new File("../db.config"));
			username = scanner.nextLine();
			password = scanner.nextLine();
			scanner.close();
			
			try {
				// register oracle driver and connect to db  
				DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
				connection = DriverManager.getConnection("jdbc:oracle:thin:@db10.cs.pitt.edu:1521:dbclass", username, password); 
			}
			catch(Exception e)  {
				System.err.println("Error connecting to database: " + e.toString());
			}
		} catch (FileNotFoundException e) {
			System.err.println("Could not find db.config file: " + e.toString());
		}
	}

	public static void main(String args[]) {
		MyAuction test = new MyAuction();
	}
}
