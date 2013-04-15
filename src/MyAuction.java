import java.io.File;
import java.io.FileNotFoundException;
import java.sql.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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
	 * @return numeric input
	 */
	public int getUserNumericInput(String prompt) {
		while (true) {
			try {
				return Integer.parseInt(getUserInput(prompt, -1));
			} catch (NumberFormatException e) {
				continue;
			}	
		}
	}
	
	/*
	 * @param prompt descriptive prompt of input
	 * @return trimmed line of required user input
	 */
	public String getUserInput(String prompt) {
		return getUserInput(prompt, true, -1);
	}
	
	/*
	 * @param prompt descriptive prompt of input
	 * @param length maximum length of input
	 * @return trimmed line of required user input
	 */
	public String getUserInput(String prompt, int length) {
		return getUserInput(prompt, true, length);
	}
	
	/*
	 * @param prompt descriptive prompt of input
	 * @param required whether input is optional or required
	 * @return trimmed line of optional or required user input
	 */
	public String getUserInput(String prompt, boolean required, int length) {
		boolean lengthCheck;
		String str;
		do {
			System.out.print(prompt + ": ");
			str = input.nextLine().trim();
			
			// check length if necessary
			if (length > 0 && str.length() > length) {
				System.out.println("Sorry, input can only be " + length + " characters (yours was " + str.length() + ").");
				lengthCheck = true;
			} else {
				lengthCheck = false;
			}
		} while(lengthCheck || required && str.isEmpty());
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
		System.out.println("\n" + title + "\n" + HR);
		for (int i = 1; i <= choices.size(); i++) {
			System.out.println("  " + i + ") " + choices.get(i - 1));
		}
		System.out.println(HR);
		
		// prompt user for input
		int choice;
		do {
			choice = getUserNumericInput(prompt);
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
	 * @param menu 0:main, 1:user, 2:admin, 3:admin_stats
	 */
	public void promptMenu(int menu) {
		// print choices
		List<String> choices = null;
		int choice = 0;
		switch(menu) {
			case 3:
				choices = Arrays.asList(
					"Highest volume leaf categories",
					"Highest volume root categories",
					"Most active bidders",
					"Most active buyers",
					"Return to admin menu"
				);
				choice = getUserChoice("Administrator statistics", choices);
				break;
			case 2:
				choices = Arrays.asList(
					"New customer registration",
					"Update system date",
					"Product statistics",
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
		if (menu == 3) {
			// deal with admin statistics menu
			int months = 0, limit = 0;
			if (choice < 5) {
				months = getUserNumericInput("Number of previous months to include");
				limit = getUserNumericInput("Please enter a limit");
			}
			switch(choice) {
				case 1:
					// Highest volume leaf categories
					topLeafCategories(months, limit);
					promptMenu(3);
					break;
				case 2:
					// Highest volume root categories
					topRootCategories(months, limit);
					promptMenu(3);
					break;
				case 3:
					// Most active bidders
					topActiveBidders(months, limit);
					promptMenu(3);
					break;
				case 4:
					// Most active buyers
					topActiveBuyers(months, limit);
					promptMenu(3);
					break;
				default:
					promptMenu(2);
					break;
			}
		} else if (menu == 2) {
			// deal with admin menu choices
			switch(choice) {
				case 1:
					// New customer registration
					registerCustomer();
					promptMenu(2);
					break;
				case 2:
					// Update system date
					updateDate();
					promptMenu(2);
					break;
				case 3:
					// Product statistics
					String customer = getUserInput("Enter customer username or leave blank to display all products", false, -1);
					productStatistics(customer);
					promptMenu(2);
					break;
				case 4:
					// Statistics
					promptMenu(3);
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
					place_bid() ;
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
	 * @param query SQL select query
	 * @param str one parameter to replace in query
	 * @return result set of query
	 */
	public ResultSet query(PreparedStatement ps, String str) {
		return query(ps, Arrays.asList(str));
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
	 * @param query SQL update query
	 * @param str one parameter to replace in query
	 * @return result of update
	 */
	public int queryUpdate(PreparedStatement ps, String str) {
		return queryUpdate(ps, Arrays.asList(str));
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
	 * @return list of leaf categories of parent
	 */
	public List<String> getLeafCategories() {
		return getLeafCategories(null);
	}
	
	/*
	 * @param parent parent category or null for root categories
	 * @return list of leaf categories of parent
	 */
	private List<String> getLeafCategories(String parent) {
		List<String> children = getCategories(parent);
		if (children == null) {
			return Arrays.asList(parent);
		} else {
			List<String> leaves = new ArrayList<String>();
			for (String child : children) {
				leaves.addAll(getLeafCategories(child));
			}
			return leaves;
		}
	}
	
	/*
	 * Registers an admin or customer.
	 */
	public void registerCustomer() {
		String name, address, email, login, password, admin ;
		System.out.println("Please provide the following information for the new user:");
		name = getUserInput("Name", 10) ;
		address = getUserInput("Address", 30) ;
		email = getUserInput("Email Address", 20) ;
		
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
				
				login = getUserInput(prompt, 10);
				result = query(statement, login);
				// sanity check (result should always be returning a count)
				if (result != null) {
					result.next();
				}
				
				firstAttempt = false;
			} while(result.getInt(1) > 0);
		} catch (SQLException e) {
			handleSQLException(e);
		}
		
		password = getUserInput("Password", 10) ;
		admin = getUserInput("Is this user an admin? (yes/no)").toLowerCase();
		
		// insert user into database
		String type = (admin.equals("yes") ? "administrator" : "customer");
		statement = getPreparedQuery("insert into " + type + " values (?, ?, ?, ?, ?)");
		result = query(statement, Arrays.asList(login, password, name, address, email));
		System.out.println("\nUser successfully added!\n") ;
	}
	
	/*
	 * Check validity of date string
	 * @param date date string
	 * @param format date format
	 * @return validity of date string
	 */
	private static boolean isDateValid(String date, String format) {
        try {
            DateFormat df = new SimpleDateFormat(format);
            df.setLenient(false);
            df.parse(date);
            return true;
        } catch (ParseException e) {
            return false;
        }
	}
	
	/*
	 * Check validity of date string on default format
	 * @param date date string
	 * @return validity of date string
	 */
	private static boolean isDateValid(String date) {
		return isDateValid(date, "dd-MM-yyyy/hh:mm:ssa");
	}
	
	/*
	 * Update our system date.
	 */
	public void updateDate() {
		String date;
		do {
			date = getUserInput("Please enter a date (must match dd-mm-yyyy/hh:mi:ssam)").toUpperCase();
		} while(!isDateValid(date));
		
		queryUpdate(getPreparedQuery("update sys_time set my_time = to_date(?, 'dd-mm-yyyy/hh:mi:ssam')"), date);
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
					choice = getUserChoice(title, cats, "Which category would you like to browse?");
					chosenCat = cats.get(choice - 1);
				}
			} while(cats != null);
			
			// prompt user for sort method
			int sort = getUserChoice("\nHow do you want your products sorted by?", Arrays.asList(
				"Highest bid first",
				"Lowest bid first",
				"Alphabetically by product name"
			), "Choose a sort option");
			
			// construct query string
			String query = "select auction_id, name, description, amount from product where status = 'underauction' and auction_id in (select auction_id from belongsto where category = '" + chosenCat + "') order by ";
			if (sort == 1) {
				query += "amount desc";
			} else if (sort == 2) {
				query += "amount asc";
			} else {
				query += "name asc";
			}
			
			// run query
			ResultSet products = query(query);
			
			if (products != null) {
				// print table heading
				String[] titles = {"id", "name", "description", "highest bid"};
				int[] widths = {5, 20, 30, 10};
				System.out.println(createTableHeading(titles, widths));
				
				// print results
				while (products.next()) {
					System.out.printf("%5d %-20s %-30s %10d\n", products.getInt(1), products.getString(2), products.getString(3), products.getInt(4));
				}
			} else {
				System.out.println("\nNo results found.");
			}
			
			promptMenu(1);
		} catch(SQLException e) {
			handleSQLException(e);
		}
	}

	//Search for products using up to two keywords
	public void search() {
		try {
			String input = getUserInput("Please enter the first keyword you would like to search by");
			String input2 = getUserInput("Enter the second keyword you would like to search by (optional)", false, -1);

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
			handleSQLException(e);
		}
	}
	
	//Place bid on product currently underauction
	//I'll finish this up later today once I get back from my meeting I have
	//Not tested at all
	public void place_bid() {
		int a_id, bid ;
		System.out.println("\nPlease provide the following bid information:");
		a_id = getUserNumericInput("Auction ID") ;
		bid = getUserNumericInput("Bid Amount") ;
		
		try {
			CallableStatement cs = connection.prepareCall("{? = call validate_bid(?, ?)}") ;
			cs.registerOutParameter(1, Types.INTEGER) ;
			cs.setInt(1, a_id) ;
			cs.setInt(2, bid) ;
			cs.execute() ;
			int output = cs.getInt(1) ;
			
			if(output == 1) {
				ResultSet resultSet ;
				resultSet = query("insert into bidlog values(1, " + a_id + ", " + username + ", (select my_time from sys_time), " + bid + ")");
			}
			else if(output == 2) 
				System.out.println("\nError: Your bid is lower than the current highest bid.\n") ;
			else
				System.out.println("\nError: You are placing a bid on an invalid product.\n") ;
		} catch (SQLException e) {
			handleSQLException(e);
		}
	}
	
	/*
	 * @param months the number of months to include in query
	 * @param k number of categories to print
	 * @return the top k highest volume leaf categories
	 */
	public void topLeafCategories(int months, int k) {
		try {
			Map<String, Integer> map = new HashMap<String, Integer>();
			List<String> cats = getLeafCategories();
			
			CallableStatement cs = connection.prepareCall("{call ?:=product_count(?, ?)}");
			for (String cat : cats) {
				cs.registerOutParameter(1, Types.INTEGER);
				cs.setInt(2, months);
				cs.setString(3, cat);
				cs.execute();
				map.put(cat, cs.getInt(1));
			}
			
			// sort map
			ValueComparator vc = new ValueComparator(map);
			Map<String, Integer> sorted = new TreeMap<String, Integer>(vc);
			sorted.putAll(map);
			
			System.out.println(HR);
			int count = 0;
			for (Map.Entry<String, Integer> cat : sorted.entrySet()) {
				System.out.println(cat.getValue() + "\t" + cat.getKey());
				count++;
				if (count == k) break;
			}
		} catch (SQLException e) {
			handleSQLException(e);
		}
	}
	
	/*
	 * @param months the number of months to include in query
	 * @param k number of categories to print
	 * @return the top k highest volume root categories
	 */
	public void topRootCategories(int months, int k) {
		try {
			Map<String, Integer> map = new HashMap<String, Integer>();
			List<String> rootCats = getCategories(null);
			
			for (String root : rootCats) {
				List<String> underRoot = new ArrayList<String>(Arrays.asList(root));
				underRoot.addAll(getChildCategories(root));
				
				// count products sold under root category
				PreparedStatement s = getPreparedQuery("select count(auction_id) from (" +
					"select distinct p.auction_id from product p join belongsto b on p.auction_id = b.auction_id " +
					"where p.status = 'sold' and p.sell_date >= add_months((select my_time from sys_time), -1 * ?) " +
					"and b.category in (" + formatList(underRoot, '\'', ", ") + "))");
				s.setInt(1, months);
				ResultSet result = s.executeQuery();
				result.next();
				map.put(root, result.getInt(1));
			}
			
			// sort map
			ValueComparator vc = new ValueComparator(map);
			Map<String, Integer> sorted = new TreeMap<String, Integer>(vc);
			sorted.putAll(map);
			
			System.out.println(HR);
			int count = 0;
			for (Map.Entry<String, Integer> cat : sorted.entrySet()) {
				System.out.println(cat.getValue() + "\t" + cat.getKey());
				count++;
				if (count == k) break;
			}
		} catch (SQLException e) {
			handleSQLException(e);
		}
	}
	
	/*
	 * @param parent parent category
	 * @return list of all categories under a parent node
	 */
	public List<String> getChildCategories(String parent) {
		List<String> children = getCategories(parent);
		if (children == null) {
			return Arrays.asList(parent);
		} else {
			List<String> result = new ArrayList<String>();
			for (String cat : children) {
				result.addAll(getChildCategories(cat));
			}
			return result;
		}
	}
	
	/*
	 * @param list list of strings
	 * @param del delimiter that will separated formated list
	 * @return formated list of strings
	 */
	public String formatList(List<String> list, char surround, String del) {
		String result = "";
		for (int i = 0; i < list.size(); i++) {
			result += surround + list.get(i) + surround;
			if (i < list.size() - 1) {
				result += del;
			}
		}
		return result;
	}
	
	public String createTableHeading(String[] titles, int[] widths) {
		String result = "\n";
		for (int i = 0; i < titles.length; i++) {
			result += String.format("%-" + widths[i] + "s ", titles[i].toUpperCase());
		}
		result += "\n";
	
		// construct hr string
		for (int i = 0; i < widths.length; i++) {
			for (int j = 0; j < widths[i]; j++) {
				result += '-';
			}
			result += ' ';
		}
		
		return result;
	}
	
	/*
	 * Prints a summary table of product statistics
	 * @param customer option seller filter
	 */
	public void productStatistics(String customer) {
		try {
			String query = "select name, status, amount as highest_bid, login, seller from (" +
				"select p.name, p.status, p.amount, b.bidder as login, p.seller from product p join bidlog b on p.auction_id = b.auction_id and p.amount = b.amount where p.status <> 'sold' " +
				"union select name, status, amount, buyer as login, seller from product where status = 'sold')";
			ResultSet result;
			if (customer.isEmpty()) {
				result = query(query);
			} else {
				query += " where seller = ?";
				PreparedStatement s = getPreparedQuery(query);
				s.setString(1, customer);
				result = s.executeQuery();
			}
			
			// print out results
			String[] titles = {"Name", "Status", "Highest Bid", "Bidder/Buyer"};
			int[] widths = {20, 20, 15, 15};
			System.out.println(createTableHeading(titles, widths));
			while(result.next()) {
				System.out.printf("%-20s %-20s %15d %-15s\n", result.getString(1), result.getString(2), result.getInt(3), result.getString(4));
			}
		} catch (SQLException e) {
			handleSQLException(e);
		}
	}
	
	/*
	 * @param months the number of months to include in query
	 * @param k number of bidders to print
	 * @return the k most active bidders
	 */
	public void topActiveBidders(int months, int k) {
		try {
			PreparedStatement s = getPreparedQuery("select * from (" +
				"select login, bid_count(login, ?) as amount from customer where bid_count(login, ?) > 0 order by amount desc) where rownum <= ?");
			s.setInt(1, months);
			s.setInt(2, months);
			s.setInt(3, k);
			ResultSet bidders = s.executeQuery();
			
			// print out results
			System.out.println(HR);
			while (bidders.next()) {
				System.out.println(bidders.getInt(2) + "\t" + bidders.getString(1));
			}
		} catch (SQLException e) {
			handleSQLException(e);
		}
	}
	
	/*
	 * @param months the number of months to include in query
	 * @param k number of bidders to print
	 * @return the k most active bidders
	 */
	public void topActiveBuyers(int months, int k) {
		try {
			PreparedStatement s = getPreparedQuery("select * from ( select login, buying_amount(login, ?) as amount" +
				" from customer where buying_amount(login, ?) is not null order by amount desc) where rownum <= ?");
			s.setInt(1, months);
			s.setInt(2, months);
			s.setInt(3, k);
			ResultSet buyers = s.executeQuery();
			
			// print out results
			System.out.println(HR);
			while (buyers.next()) {
				System.out.println(buyers.getInt(2) + "\t" + buyers.getString(1));
			}
		} catch (SQLException e) {
			handleSQLException(e);
		}
	}
	
	/*
	 * Class used to sort results of various statistic queries. Sorts
	 * descending and uses keys as a tiebraker.
	 */
	private static class ValueComparator implements Comparator<String> {
        private Map<String, Integer> base;
        
        ValueComparator(Map<String, Integer> base) {
            this.base = base;
        }
        
        public int compare(String a, String b) {
            Integer x = base.get(a);
            Integer y = base.get(b);
            if (x.equals(y)) {
                return a.compareTo(b);
            }
            return y.compareTo(x);
        }
    }

	public static void main(String args[]) {
		MyAuction test = new MyAuction();
	}
}
