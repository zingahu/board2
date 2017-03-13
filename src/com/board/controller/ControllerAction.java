package com.board.controller;

import java.io.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

public class ControllerAction extends HttpServlet {
	private Map commandMap = new HashMap<>();// 명령어와 명령어 처리 클래스를 쌍으로 저장

	public void init(ServletConfig config) throws ServletException {

		loadProperties("com/board/properties/Command");
	}

	private void loadProperties(String path) {
		ResourceBundle rbHome = ResourceBundle.getBundle(path);// 누구를 실행할 지를 rb에
																// 저장

		Enumeration<String> actionEnumHome = rbHome.getKeys();
		while (actionEnumHome.hasMoreElements()) {
			String command = actionEnumHome.nextElement();
			String className = rbHome.getString(command);
			try {
				Class commandClass = Class.forName(className);// 해당 문자열을 클래스로
																// 만든다.
				Object commandInstance = commandClass.newInstance();// 해당 클래스의
																	// 객체를 생성
				commandMap.put(command, commandInstance);

			} catch (ClassNotFoundException e) {
				continue;// error

			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}

	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		requestPro(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		requestPro(request, response);

	}

	// 사용자의 요청을 분석해서 해당작업을 처리
	private void requestPro(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String view = null;
		CommandAction com = null;
		try {
			String command = request.getRequestURI();
			if (command.indexOf(request.getContextPath()) == 0) {
				command = command.substring(request.getContextPath().length());
			}
			com = (CommandAction) commandMap.get(command);
			if (com == null) {
				System.out.println("not found : " + command);
				return;
			}
			view = com.requestPro(request, response);
			if (view == null) {
				return;
			}

		} catch (Throwable e) {
			throw new ServletException(e);
		}
		if (view == null)
			return;
		RequestDispatcher dispatcher = request.getRequestDispatcher(view);
		dispatcher.forward(request, response);
	}

}
