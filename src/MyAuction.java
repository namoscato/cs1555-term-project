import java.io.File;
import java.io.FileNotFoundException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class MyAuction {
	private Connection connection;
	private String username, password;
	private Scanner input;
	
	private static final String HR = "--------------------------------------";
	
	public MyAuction() {
		try {
			// get username and password
			Scanner scanner = new Scanner(new File("db.config"));
			String username = scanner.nextLine();
			String password = scanner.nextLine();
			scanner.close();
			
			try {
				// register oracle driver and connect to db
				// must be on unixs.cis.pitt.edu and run "source ~panos/1555/bash.env"
				DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
				connection = DriverManager.getConnection("jdbc:oracle:thin:@db10.cs.pitt.edu:1521:dbclass", username, password);
				input = new Scanner(System.in);
				
				System.out.println("Welcome to MyAuction!");
				promptMenu(0);
			} catch(SQLException e)  {
				System.err.println("Error connecting to database: " + e.toString());
			}
		} catch (FileNotFoundException e) {
			System.err.println("Could not find db.config file: " + e.toString());
		}
	}
	
	/*
	 * @param prompt descriptive prompt of input
	 * @return trimmed line of required user input
	 */
	public String getUserInput(String prompt) {
		return getUserInput(prompt, true);
	}
	
	/*
	 * @param prompt descriptive prompt of input
	 * @param required whether input is optional or required
	 * @return trimmed line of optional or required user input
	 */
	public String getUserInput(String prompt, boolean required) {
		String str;
		do {
			System.out.print(prompt + ": ");
			str = input.nextLine().trim();
		} while(required && str.isEmpty());
		return str;
	}
	
	/*
	 * Prints a formatted list of choices and prompts the user for input
	 * @param title title of choices
	 * @param choices list of choices
	 * @param prompt descriptive prompt for user input
	 * @return user's choice
	 */
	public int getUserChoice(String title, List<String> choices, String prompt) {
		// print choices
		System.out.println(title + "\n" + HR);
		for (int i = 1; i <= choices.size(); i++) {
			System.out.println("  " + i + ") " + choices.get(i - 1));
		}
		System.out.println(HR);
		
		// prompt user for input
		int choice;
		do {
			try {
				choice = Integer.parseInt(getUserInput(prompt));
			} catch (NumberFormatException e) {
				choice = 0;
			}
			
		} while (choice <= 0 || choice > choices.size());
		return choice;
	}
	
	/*
	 * Prints a formatted list of choices and prompts the user for input
	 * with a default descriptive prompt.
	 * @param title title of choices
	 * @param choices list of choices
	 * @return user's choice
	 */
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
					registerCustomer() ;
					break;
				case 2:
					// Update system date
					updateDate();
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
					browse();
					break;
				case 2:
					// Search products
					search();
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
	 * @param e exception
	 */
	public void handleSQLException(Exception e) {
		System.err.println("Error running database query: " + e.toString());
		e.printStackTrace();
		System.exit(1);
	}
	
	/*
	 * @param query SQL select query
	 * @return result set of query or null if empty
	 */
	public ResultSet query(String query) {
		try {
			Statement s = connection.createStatement();
			ResultSet result = s.executeQuery(query);
			// check to see if result is empty
			if (result.isBeforeFirst()) {
				return result;
			} else {
				return null;
			}
		} catch (SQLException e) {
			handleSQLException(e);
			return null;
		}
	}
	
	/*
	 * @param query SQL query with some question marks
	 * @return prepared statement ready for input
	 */
	public PreparedStatement getPreparedQuery(String query) {
		try {
			return connection.prepareStatement(query);
		} catch (SQLException e) {
			handleSQLException(e);
			return null;
		}
	}
	
	/*
	 * @param query SQL select query
	 * @param parameters list of string parameters to replace in query
	 * @return result set of query
	 */
	public ResultSet query(PreparedStatement ps, List<String> parameters) {
		try {
			for (int i = 1; i <= parameters.size(); i++) {
				ps.setString(i, parameters.get(i - 1));
			}
			ResultSet result = ps.executeQuery();
			
			// check to see if result is empty
			if (result.isBeforeFirst()) {
				return result;
			} else {
				return null;
			}
		} catch (SQLException e) {
			handleSQLException(e);
			return null;
		}
	}
	
	/*
	 * @param query SQL update query
	 * @param parameters list of string parameters to replace in query
	 * @return result of update
	 */
	public int queryUpdate(PreparedStatement ps, List<String> parameters) {
		try {
			for (int i = 1; i <= parameters.size(); i++) {
				ps.setString(i, parameters.get(i - 1));
			}
			return ps.executeUpdate();
		} catch (SQLException e) {
			handleSQLException(e);
			return -1;
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
			username = getUserInput("Username");
			password = getUserInput("Password");

			//checking to make sure the usn/pwd match something in the database
			ResultSet resultSet;
			if(type == 2) //Which database to check for the login info
				resultSet = query("select login, password from customer");
			else
				resultSet = query("select login, password from administrator");
			while(resultSet.next())
			{
				if(username.equals(resultSet.getString(1)) && password.equals(resultSet.getString(2)))
					return true ; //Username/password combo was found!
			}
			return false ; //If there was no match for the username/password, return false

		} catch(SQLException e) {
			handleSQLException(e);
			return false;
		}
	}
	
	/*
	 * @param parent parent category or null for root categories
	 * @return list of categories with specified parent
	 */
	public List<String> getCategories(String parent) {
		ResultSet r;
		if (parent == null) {
			r = query("select name from category where parent_category is null");
		} else {
			r = query("select name from category where parent_category = '" + parent + "'");
		}
		
		List<String> cats = new ArrayList<String>();
		if (r != null) {
			try {
				while (r.next()) {
					cats.add(r.getString(1));
				}
				return cats;
			} catch (SQLException e) {
				handleSQLException(e);
				return null;
			}
		} else {
			// return null if result set is empty
			return null;
		}
	}
	
	/*
	 * Registers an admin or customer.
	 */
	public void registerCustomer() {
		String name, address, email, login, password, admin ;
		System.out.println("Please provide the following information for the new user:");
		name = getUserInput("Name") ;
		address = getUserInput("Address") ;
		email = getUserInput("Email Address") ;
		
		// make sure username doesn't already exist
		login = "";
		PreparedStatement statement = getPreparedQuery("select count(login) from customer where login = ?");
		ResultSet result = null;
		boolean firstAttempt = true;
		String prompt = "Username";
		try {
			do {
				if (!firstAttempt) {
					prompt = "Username already exists! Please enter another";
				}
				
				login = getUserInput(prompt);
				result = query(statement, Arrays.asList(login));
				// sanity check (result should always be returning a count)
				if (result != null) {
					result.next();
				}
				
				firstAttempt = false;
			} while(result.getInt(1) > 0);
		} catch (SQLException e) {
			handleSQLException(e);
		}
		
		password = getUserInput("Password") ;
		admin = getUserInput("Is this user an admin? (yes/no)").toLowerCase();
		
		// insert user into database
		String type = (admin.equals("yes") ? "administrator" : "customer");
		statement = getPreparedQuery("insert into " + type + " values (?, ?, ?, ?, ?)");
		result = query(statement, Arrays.asList(login, password, name, address, email));
		
		promptMenu(2);
	}
	
	/*
	 * Update our system date.
	 */
	public void updateDate() {
		String date = getUserInput("\nWhat do you want to set the date to? Please follow this format:\ndd-mm-yyyy/hh:mi:ssam\n");
		// probably easier to validate string with java because a bunch of different exceptions could be thrown
		queryUpdate(getPreparedQuery("update sys_time set my_time = to_date(?, 'dd-mm-yyyy/hh:mi:ssam')"), Arrays.asList(date));
		promptMenu(2);
	}
	
	/*
	 * Browse through products of a specific category
	 */
	public void browse() {
		try {
			// traverse through hierarchical categories
			List<String> cats = null;
			String chosenCat = null;
			int choice = 0;
			do {
				cats = getCategories(chosenCat);
				if (cats != null) {
					String title = (chosenCat == null ? "Categories" : chosenCat);
					choice = getUserChoice("\n" + title, cats, "Which category would you like to browse?");
					chosenCat = cats.get(choice - 1);
				}
			} while(cats != null);
			
			// prompt user for sort method
			int sort = getUserChoice("How do you want your products sorted by?", Arrays.asList(
				"Highest bid first",
				"Lowest bid first",
				"Alphabetically by product name"
			), "Choose a sort option");

			ResultSet resultSet = null ;
			if(sort == 1)
				resultSet = query("select auction_id, name, description, amount from product where status = 'underauction' and auction_id in (select auction_id from belongsto where category = '" + chosenCat + "') order by amount desc") ;
			else if(sort == 2)
				resultSet = query("select auction_id, name, description, amount from product where status = 'underauction' and auction_id in (select auction_id from belongsto where category = '" + chosenCat + "') order by amount asc") ;
			else if(sort == 3)
				resultSet = query("select auction_id, name, description, amount from product where status = 'underauction' and auction_id in (select auction_id from belongsto where category = '" + chosenCat + "') order by name asc") ;
			else
				System.out.println("Error: Please enter a valid number.") ;
			
			System.out.println("\nSearch Results: ") ;
			while(resultSet.next()) {
				System.out.println("Auction ID: " + resultSet.getInt(1) + ", Product: " + resultSet.getString(2)
						+ ", Description: " + resultSet.getString(3) + ", Highest Bid: " + resultSet.getInt(4)) ;
			}
		
			promptMenu(1);
		} catch(SQLException e) {
			System.out.println("Error running database queries: " + e.toString());
		}
	}

	//Search for products using up to two keywords
	public void search() {
		try {
			String input = getUserInput("Please enter the first keyword you would like to search by");
			String input2 = getUserInput("Enter the second keyword you would like to search by (optional)", false);

			ResultSet resultSet;
			String temp = "";
			List<String> params;
			if (input2.equals("")) {
				params = Arrays.asList(input);
			} else {
				temp = " and upper(description) like upper('%?%')";
				params = Arrays.asList(input, input2);
			}
			PreparedStatement statement = getPreparedQuery("select auction_id, name, description from product where upper(description) like upper('%?%')" + temp);
			resultSet = query(statement, params);
						
			System.out.println("\nSearch Results: ") ;
			if (resultSet != null) {
				while(resultSet.next()) {
					System.out.println("Auction ID: " + resultSet.getInt(1) + ", Product: " + resultSet.getString(2) + ", Description: " + resultSet.getString(3)) ;
				}	
			} else {
				System.out.println("No products found.");
			}
			promptMenu(1);
		} catch(SQLException e) {
			System.out.println("Error running database queries: " + e.toString());
		}
	}

	public static void main(String args[]) {
		MyAuction test = new MyAuction();
	}
}
