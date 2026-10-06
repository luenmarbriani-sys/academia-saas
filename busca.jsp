<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="conexao.jspf" %>
<%
request.setCharacterEncoding("utf-8");
String nomeBusca = request.getParameter("nomeBusca");
if (nomeBusca == null) nomeBusca = "";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
	<meta charset="utf-8">
	<title>Consulta de alunos</title>
	<link rel="stylesheet" href="estilo.css">
</head>
<body>
	<nav>
		<a href="checkin.jsp">Registrar check-in</a>
		<a href="busca.jsp">Consultar alunos</a>
	</nav>
	<h1>Consultar alunos</h1>

	<form method="post" action="busca.jsp">
		<p>Aluno
			<input type="text" size="20" name="nomeBusca" value="<%=esc(nomeBusca)%>">
			<input type="submit" value="Encontrar">
		</p>
	</form>

<%
Connection conn = null;
try {
	conn = abrirConexao();

	// Junta as 3 tabelas: aluno + plano + resumo dos check-ins.
	// LEFT JOIN para mostrar também quem ainda não fez nenhum check-in.
	PreparedStatement ps = conn.prepareStatement(
		"SELECT a.nome_aluno, p.nome_plano, p.valor_mensal, a.data_matricula, " +
		"       COUNT(c.id_checkin) AS total_checkins, MAX(c.data_checkin) AS ultimo_checkin " +
		"FROM alunos a " +
		"INNER JOIN planos p ON p.id_plano = a.id_plano " +
		"LEFT JOIN checkins c ON c.id_aluno = a.id_aluno " +
		"WHERE a.nome_aluno LIKE ? " +
		"GROUP BY a.id_aluno, a.nome_aluno, p.nome_plano, p.valor_mensal, a.data_matricula " +
		"ORDER BY a.nome_aluno");
	ps.setString(1, "%" + nomeBusca + "%");
	ResultSet rs = ps.executeQuery();
%>
	<table>
		<tr>
			<th>Aluno</th><th>Plano</th><th>Mensalidade</th><th>Matrícula</th>
			<th>Check-ins</th><th>Último check-in</th>
		</tr>
	<% while (rs.next()) {
		java.sql.Date ultimo = rs.getDate("ultimo_checkin"); %>
		<tr>
			<td><%=esc(rs.getString("nome_aluno"))%></td>
			<td><%=esc(rs.getString("nome_plano"))%></td>
			<td>R$ <%=rs.getBigDecimal("valor_mensal")%></td>
			<td><%=rs.getDate("data_matricula")%></td>
			<td><%=rs.getInt("total_checkins")%></td>
			<td><%=ultimo == null ? "-" : ultimo.toString()%></td>
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
