<%@page import="java.sql.*, java.io.*, java.net.URLConnection"%>

<%
Class.forName("com.mysql.jdbc.Driver");

  Connection conn = null;
  Statement stmt = null;
  ResultSet rs = null;
  try {
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/libgenNep", "hbstudent", "Hb@student");
    stmt = conn.createStatement();
    rs = stmt.executeQuery("SELECT * FROM books");
%>
  <table>
    <thead>
      <tr>
        <th>Title</th>
        <th>Author</th>
        <th>Download</th>
      </tr>
    </thead>
    <tbody>
<%
    while (rs.next()) {
      String title = rs.getString("title");
      String author = rs.getString("author");
      String filename = rs.getString("filename");
      String filepath = rs.getString("filepath");
%>
      <tr>
        <td><%= title %></td>
        <td><%= author %></td>
        <td><a href="download.jsp?filepath=<%= filepath %>"><%= filename %></a></td>
      </tr>
<%
    }
%>
    </tbody>
  </table>
<%
  } catch (SQLException ex) {
    ex.printStackTrace();
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
  } finally {
    try {
      if (rs != null) rs.close();
      if (stmt != null) stmt.close();
      if (conn != null) conn.close();
    } catch (SQLException ex) {
      ex.printStackTrace();
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }
%>
