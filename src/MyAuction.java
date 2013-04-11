import java.io.File;
import java.io.FileNotFoundException;
import java.sql.*;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class MyAuction {
	private Connection connection; //used to hold the jdbc connection to the DB
	private Statement statement; //used to create an instance of the connection
	private ResultSet resultSet; //used to hold the result of your query (if one // exists)
	private String query;  //this will hold the query we are using
	private String username, password;
	private Scanner input;
	
	private static final String HR = "--------------------------------------";
	
	public MyAuction() {
		try {
			// get username and password
			Scanner scanner = new Scanner(new File("db.config"));
			username = scanner.nextLine();
			password = scanner.nextLine();
			scanner.close();
			
			try {
				// register oracle driver and connect to db
				// must be on unixs.cis.pitt.edu and run "source ~panos/1555/bash.env"
				DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
				connection = DriverManager.getConnection("jdbc:oracle:thin:@db10.cs.pitt.edu:1521:dbclass", username, password);
				input = new Scanner(System.in);
				
				System.out.println("Welcome to MyAuction!");
				promptMenu(0);
			}
			catch(Exception e)  {
				System.err.println("Error connecting to database: " + e.toString());
			}
		} catch (FileNotFoundException e) {
			System.err.println("Could not find db.config file: " + e.toString());
		}
	}
	
	/*
	 * @param prompt descriptive prompt of input
	 * @return trimmed line of user input
	 */
	public String getUserInput(String prompt) {
		System.out.print(prompt + ": ");
		return input.nextLine().trim();
	}
	
	/*
	 * @param title title of menu
	 * @param choices list of menu choices
	 * @param prompt descriptive prompt for user input
	 */
	public int getUserChoice(String title, List<String> choices, String prompt) {
		// print choices
		System.out.println(prompt + "\n" + HR);
		for (int i = 1; i <= choices.size(); i++) {
			System.out.println("  " + i + ") " + choices.get(i - 1));
		}
		System.out.println(HR);
		
		// prompt user for input
		int choice;
		do {
			choice = Integer.parseInt(getUserInput(prompt));
		} while (choice <= 0 || choice > choices.size());
		return choice;
	}
	
	public int getUserChoice(String title, List<String> choices) {
		return getUserChoice(title, choices, "Choose a menu item");
	}
	
	/*
	 * Prints menu and prompts user input
	 * @param menu 0:main, 1:user, 2:admin
	 */
	public void promptMenu(int menu) {
		System.out.println();
		// print choices
		List<String> choices = null;
		int choice = 0;
		switch(menu) {
			case 2:
				choices = Arrays.asList(
					"New customer registration",
					"Update system date",
					"Statistics",
					"Logout"
				);
				choice = getUserChoice("Administrator menu", choices);
				break;
			case 1:
				choices = Arrays.asList(
					"Browse products",
					"Search products",
					"Auction product",
					"Bid on product",
					"Sell product",
					"Show suggestions",
					"Logout"
				);
				choice = getUserChoice("User menu", choices);
				break;
			default:
				choices = Arrays.asList(
					"Administrator login",
					"User login",
					"Exit"
				);
				choice = getUserChoice("Main menu", choices);
				break;
		}
		
		// handle user's choice
		System.out.println("\n" + choices.get(choice - 1));
		if (menu == 2) {
			// deal with admin menu choices
			switch(choice) {
				case 1:
					// New customer registration
					break;
				case 2:
					// Update system date
					break;
				case 3:
					// Statistics
					break;
				default:
					promptMenu(0);
					break;
			}
		} else if (menu == 1) {
			// deal with user menu choices
			switch(choice) {
				case 1:
					// Browse products
					break;
				case 2:
					// Search products
					break;
				case 3:
					// Auction product
					break;
				case 4:
					// Bid on product
					break;
				case 5:
					// Sell product
					break;
				case 6:
					// Show suggestions
					break;
				default:
					promptMenu(0);
					break;
			}
		} else {
			// deal with main menu choices
			switch(choice) {
				case 1:
					// administrator login
					if (login(1)) {
						promptMenu(2);
					} else {
						System.out.println("Error! Invalid username/password!");
						promptMenu(0);
					}
					break;
				case 2:	
					// user login
					if (login(2)) {
						promptMenu(1);
					} else {
						System.out.println("Error! Invalid username/password!");
						promptMenu(0);
					}
					break;
				default:
					System.out.println("Goodbye!");
					break;
			}
		}
	}
	
	/*
	 * @param type 1:admin, 2:user
	 * @return successful or invalid login
	 */
	public boolean login(int type) {
		try {

			if(type != 1 && type != 2)
				System.out.println("You should never ever see this output.") ;
			
			System.out.println("\nPlease enter your login information.");
			String username = getUserInput("Username");
			String password = getUserInput("Password");

			//checking to make sure the usn/pwd match something in the database
			statement = connection.createStatement() ;
			if(type == 2) //Which database to check for the login info
				query = "select login, password from customer" ;
			else
				query = "select login, password from administrator" ;
			resultSet = statement.executeQuery(query) ;
			while(resultSet.next())
			{
				if(username.equals(resultSet.getString(1)) && password.equals(resultSet.getString(2)))
					return true ; //Username/password combo was found!
			}
			return false ; //If there was no match for the username/password, return false

		}
		catch(Exception e) {
			System.out.println("Error running database queries: " + e.toString());
		}
		return false ; //This should really never happen. I'm just making java happy
	}
	
	public void browse()
	{
		try{
		String input = getUserInput("What category do you want to search in?");
		
		statement = connection.createStatement() ;
		//Need some way of listing the categories to get more specific.
		//Any idea for the best way to do this?
		
		int sort = getUserChoice("How do you want your products sorted by?", Arrays.asList(
			"Highest bid first",
			"Lowest bid first",
			"Alphabetically by product name"
		), "Choose a sort option");
		if(sort == 1)
			query = "" ; //Will be added after categories
		else if(sort == 2)
			query = "" ;
		else if(sort == 3)
			query = "" ;
		else
			System.out.println("Error: You did not enter 1, 2, or 3.") ;
		
		//Once the category thing is sorted out, I can easily add the queries and then
		//add a few lines to display the output.
		
		}
		catch(Exception Ex) {
	    System.out.println("Error running the sample queries.  Machine Error: " +
			       Ex.toString());
		}
	}
	
	public void search()
	{
		try{
	
		
		String input = getUserInput("Please enter the first keyword you would like to search by");
		String input2 = getUserInput("Enter the second keyword you would like to search by, or leave "
			+ "this field blank if you only want to use one keyword");
		
		PreparedStatement updateStatement ;
		if(input2.equals(""))
		{
			query = "select auction_id, name, description from product where upper(description) like upper('%?%')" ;
			updateStatement = connection.prepareStatement(query) ;
			updateStatement.setString(1, input) ;
		}
		else
		{
			query = "select auction_id, name, description from product where upper(description) like upper('%?%') and upper(description) like upper('%?%')" ;
			updateStatement = connection.prepareStatement(query) ;
			updateStatement.setString(1, input) ;
			updateStatement.setString(2, input2) ;
		}
		resultSet = updateStatement.executeQuery(query) ;
		System.out.println("\nSearch Results: ") ;
		while(resultSet.next())
		{
			System.out.println("Auction ID: " + resultSet.getInt(1) + ", Product: " + resultSet.getString(2)
					+ ", Description: " + resultSet.getString(3)) ;
		}
	
		} //end try
		catch(Exception Ex) {
	    System.out.println("Error running the sample queries.  Machine Error: " +
			       Ex.toString());
		}
	}

	public static void main(String args[]) {
		MyAuction test = new MyAuction();
	}
}
