package libGenNep.rabindra;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * Servlet implementation class UploadServlet
 */
@MultipartConfig
@WebServlet("/UploadServlet")
public class UploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UploadServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String title = request.getParameter("title");
		String author = request.getParameter("author");
		Part filePart = request.getPart("file");
		String filename = filePart.getSubmittedFileName();
		String filepath = "https://mega.nz/folder/JC0mBIra#WT09vVtBIu59V4gRuv8h1Q/" + filename;

		// Save the file to the upload directory
		filePart.write(filepath);

		// Insert the book metadata into the database
		Connection conn = null;
		PreparedStatement stmt = null;
		try {
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydatabase", "username", "password");
			stmt = conn.prepareStatement("INSERT INTO books (title, author, filename, filepath) VALUES (?, ?, ?, ?)");
			stmt.setString(1, title);
			stmt.setString(2,author);
			stmt.setString(3, filename);
			stmt.setString(4, filepath);
			stmt.executeUpdate();
			response.sendRedirect("books.jsp"); // Redirect to the book list page
		} catch (SQLException ex) {
			ex.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		} finally {
			try {
				if (stmt != null) stmt.close();
				if (conn != null) conn.close();
			} catch (SQLException ex) {
				ex.printStackTrace();
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
		}
	}

}
