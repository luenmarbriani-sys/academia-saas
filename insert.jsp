<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="conexao.jspf" %>
<%
Connection conn = null;
try {
	conn = abrirConexao();

	int idAluno = Integer.parseInt(request.getParameter("id_aluno"));
	java.sql.Date data = java.sql.Date.valueOf(request.getParameter("data_checkin")); // formato aaaa-mm-dd

	// id_checkin não é IDENTITY, então o próximo número é calculado no próprio INSERT
	PreparedStatement ps = conn.prepareStatement(
		"INSERT INTO checkins (id_checkin, id_aluno, data_checkin) " +
		"SELECT ISNULL(MAX(id_checkin), 0) + 1, ?, ? FROM checkins");
	ps.setInt(1, idAluno);
	ps.setDate(2, data);
	ps.executeUpdate();

	response.sendRedirect("checkin.jsp?ok=1");

} catch (Exception e) {
	out.print("<p style='color:#c62828'>Erro ao registrar o check-in: " + esc(e.getMessage()) + "</p>");
	out.print("<p><a href='checkin.jsp'>Voltar</a></p>");
} finally {
	if (conn != null) try { conn.close(); } catch (Exception ignorar) {}
}
%>
