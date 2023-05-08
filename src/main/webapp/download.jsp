<%@page import="java.io.*, java.net.URLConnection"%>
<%
  String filepath = request.getParameter("filepath");
  if (filepath != null) {
    String filename = filepath.substring(filepath.lastIndexOf("/") + 1);
    String mimeType = URLConnection.guessContentTypeFromName(filename);
    if (mimeType == null) {
      mimeType = "application/octet-stream";
    }
    response.setContentType(mimeType);
    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

    InputStream inputStream = null;
    OutputStream outputStream = null;
    try {
      inputStream = new FileInputStream(new File(filepath));
      outputStream = response.getOutputStream();
      byte[] buffer = new byte[4096];
      int bytesRead = -1;
      while ((bytesRead = inputStream.read(buffer)) != -1) {
        outputStream.write(buffer, 0, bytesRead);
      }
    } catch (IOException ex) {
      ex.printStackTrace();
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } finally {
      try {
        if (inputStream != null) inputStream.close();
        if (outputStream != null) outputStream.close();
      } catch (IOException ex) {
        ex.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      }
    }
  } else {
    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
  }
%>
