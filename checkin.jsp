<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="conexao.jspf" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
	<meta charset="utf-8">
	<title>Check-in</title>
	<link rel="stylesheet" href="estilo.css">
</head>
<body>
	<nav>
		<a href="checkin.jsp">Registrar check-in</a>
		<a href="busca.jsp">Consultar alunos</a>
	</nav>
	<h1>Registrar check-in</h1>

	<% if ("1".equals(request.getParameter("ok"))) { %>
		<p class="ok">Check-in registrado.</p>
	<% } %>

<%
Connection conn = null;
try {
	conn = abrirConexao();

	// Lista de alunos (com o plano) para o campo de seleção
	PreparedStatement psAlunos = conn.prepareStatement(
		"SELECT a.id_aluno, a.nome_aluno, p.nome_plano " +
		"FROM alunos a INNER JOIN planos p ON p.id_plano = a.id_plano " +
		"ORDER BY a.nome_aluno");
	ResultSet rsAlunos = psAlunos.executeQuery();
%>
	<form method="post" action="insert.jsp">
		<p>Aluno
			<select name="id_aluno" required>
			<% while (rsAlunos.next()) { %>
				<option value="<%=rsAlunos.getInt("id_aluno")%>">
					<%=esc(rsAlunos.getString("nome_aluno"))%> (<%=esc(rsAlunos.getString("nome_plano"))%>)
				</option>
			<% } %>
			</select>
		</p>
		<p>Data
			<input type="date" name="data_checkin" value="<%=new java.sql.Date(System.currentTimeMillis())%>" required>
		</p>
		<p><input type="submit" value="Registrar"></p>
	</form>

<%
	// Últimos check-ins, para conferir que a inserção funcionou
	PreparedStatement psUltimos = conn.prepareStatement(
		"SELECT TOP 10 c.id_checkin, a.nome_aluno, c.data_checkin " +
		"FROM checkins c INNER JOIN alunos a ON a.id_aluno = c.id_aluno " +
		"ORDER BY c.id_checkin DESC");
	ResultSet rsUltimos = psUltimos.executeQuery();
%>
	<h2>Últimos check-ins</h2>
	<table>
		<tr><th>Nº</th><th>Aluno</th><th>Data</th></tr>
	<% while (rsUltimos.next()) { %>
		<tr>
			<td><%=rsUltimos.getInt("id_checkin")%></td>
			<td><%=esc(rsUltimos.getString("nome_aluno"))%></td>
			<td><%=rsUltimos.getDate("data_checkin")%></td>
		</tr>
	<% } %>
	</table>
<%
} catch (Exception e) {
%>
	<p class="erro">Erro ao acessar o banco: <%=esc(e.getMessage())%></p>
<%
} finally {
	if (conn != null) try { conn.close(); } catch (Exception ignorar) {}
}
%>
</body>
</html>
