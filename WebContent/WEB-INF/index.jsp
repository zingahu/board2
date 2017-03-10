<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.board.beans.Board"%>
<%@ page import="java.util.ArrayList"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<style type="text/css">
table, td, th {
	border: 1px solid green;
}

th {
	background-color: green;
	color: white;
}
</style>
</head>
<body>
	<%
		try {
			String driverName = "oracle.jdbc.driver.OracleDriver";
			String url = "jdbc:oracle:thin:@localhost:1521:XE";
			ResultSet rs = null;

			Class.forName(driverName);
			Connection con = DriverManager.getConnection(url, "board", "board");
			out.println("Oracle Database Connection Success.");

			Statement stmt = con.createStatement();
			String sql = "select * from board order by idx desc";
			rs = stmt.executeQuery(sql);

			ArrayList<Board> articleList = new ArrayList<Board>();// 이코드는 Board형 배열형식으로 선언

			while (rs.next()) {
				Board article = new Board();//데이터를 담기위해 Board객체에 메모리를 할당
				article.setIdx(rs.getInt("idx"));
				article.setTitle(rs.getString("title"));
				article.setWrite(rs.getString("write"));
				article.setRegdate(rs.getString("regdate"));
				article.setCount(rs.getInt("count"));
				articleList.add(article);//셋팅된 빈을 리스트에 추가

			}

			request.setAttribute("articleList", articleList);//셋팅된 빈을 리스트를 뷰에 포워드

			con.close();
		} catch (Exception e) {
			out.println("Oracle Database Connection Something Problem. <hr>");
			out.println(e.getMessage());
			e.printStackTrace();
		}
	%>
	<h1>게시글리스트</h1>
	<table>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>날짜</th>
			<th>조히수</th>
		</tr>
		<c:forEach items="${articleList } var="article">
			<tr>
				<td>${article.idx }</td>
				<td><a href='content.jsp?idx=${article.idx}'>${article.title }</a></td>
				<td>${article.wrtier }</td>
				<td>${article.regdate }</td>
				<td>${article.count }</td>
			</tr>
		</c:forEach>

	</table>
	<a href="write.jsp">글쓰기</a>

</body>
</html>