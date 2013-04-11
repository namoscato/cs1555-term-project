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
	
	private static final String HR = "--------------------------------------";
	
	/*
	 * Prints menu and prompts user input
	 * @param menu 0:main, 1:user, 2:admin
	 */
	public void promptMenu(int menu) {
		System.out.println();
		// print choices
		List<String> choices = null;
		switch(menu) {
			case 2:
				System.out.println("Administrator Menu\n" + HR);
				choices = Arrays.asList(
					"New customer registration",
					"Update system date",
					"Statistics"
				);
				break;
			case 1:
				System.out.println("User Menu\n" + HR);
				choices = Arrays.asList(
					"Browse products",
					"Search products",
					"Auction product",
					"Bid on product",
					"Sell product",
					"Show suggestions"
				);
				break;
			default:
				System.out.println("Main Menu\n" + HR);
				choices = Arrays.asList(
					"Administrator login",
					"User login"
				);
				break;
		}
		for (int i = 1; i <= choices.size(); i++) {
			System.out.println("  " + i + ") " + choices.get(i - 1));
		}
		System.out.println(HR);
		
		// prompt for user input
		Scanner in = new Scanner(System.in);
		boolean valid = false;
		do {
			System.out.print("Choose a menu item: ");
			int choice = in.nextInt();
			
			// if input is valid, execute task
			if (choice > 0 && choice <= choices.size()) {
				System.out.println("\n" + choices.get(choice - 1));
				if (menu == 2) {
					// deal with admin menu choices
				} else if (menu == 1) {
					// deal with user menu choices
				} else {
					// deal with main menu choices
					switch(choice) {
						case 1:
							if(login(1))
								promptMenu(2);
							else
								System.out.println("Error! Invalid username/password!") ;
							break;
						case 2:	
							if(login(2))
								promptMenu(1);
							else
								System.out.println("Error! Invalid username/password!") ;
							break;
						default:
							break;
					}
				}
				valid = true;
			}
		} while(!valid);
	}
	
	public boolean login(int type) //Basic login function
	{
		try{
	
		if(type != 1 && type != 2)
			System.out.println("You should never ever see this output.") ;
	
		Scanner scan = new Scanner(System.in) ;
		String username = null ;
		String password = null ;
		System.out.println("\nPlease enter your login information.\nUsername: ") ;
		username = scan.nextLine() ;
		System.out.println("Password: ") ;
		password = scan.nextLine() ;
		
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
		catch(Exception Ex) {
	    System.out.println("Error running the sample queries.  Machine Error: " +
			       Ex.toString());
		}
		return false ; //This should really never happen. I'm just making java happy
	}
	
	public void browse()
	{
		try{
	
		Scanner scanner = new Scanner(System.in) ;
		System.out.println("What category do you want to searh in?") ;
		String input = scanner.nextLine() ;
		
		statement = connection.createStatement() ;
		//Need some way of listing the categories to get more specific.
		//Any idea for the best way to do this?
		
		System.out.println("How do you want your products sorted by? (enter the corresponding number)\n"
		+ "1. Highest Bid First\n2.Lowest Bid First\n3. Alphabetically by product name") ;
		int sort = scanner.nextInt() ;
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
	
		Scanner scanner = new Scanner(System.in) ;
		System.out.println("Please enter the first keyword you would like to search by: ") ;
		String input = scanner.nextLine() ;
		System.out.println("Enter the second keyword you would like to search by, or leave "
		+ "this field blank if you only want to use one keyword: " ) ;
		String input2 = scanner.nextLine() ;
		
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

	public static void main(String args[]) {
		MyAuction test = new MyAuction();
	}
}
