<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="esapi" uri="http://www.owasp.org/index.php/Category:OWASP_Enterprise_Security_API" %>
<div id="individuals-div">						

	<c:set var="answerSet" value="${paging.items[0]}"></c:set>	
	
	<c:choose>
		<c:when test="${publication != null}">
			<div style="position: relative; margin-left: auto; margin-right: auto; text-align: center; margin-bottom: 10px; margin-top: 20px;">
		</c:when>
		<c:otherwise>
			<div style="position: relative; margin-left: auto; margin-right: auto; text-align: center; margin-bottom: 10px; margin-top: 10px;">
		</c:otherwise>
	</c:choose>		

		<div style="position: relative; margin-left: auto; margin-right: auto; text-align: center; width:350px; margin-bottom: 10px; margin-top: 10px;">
			<a data-toggle="tooltip" title="<spring:message code="label.GoToPreviousPage"/>" onclick="individualsMoveTo('previous', $(this).parent().parent());" class="widget-move-previous iconbutton disabled"><span class="glyphicon glyphicon-chevron-left"></span></a>				
			<span class="widget-first firstResultIndividual" style="margin-left: 10px; margin-right: 10px;">1</span>	
			<a data-toggle="tooltip" title="<spring:message code="label.GoToNextPage"/>" onclick="individualsMoveTo('next', $(this).parent().parent());" class="widget-move-next iconbutton"><span class="glyphicon glyphicon-chevron-right"></span></a>
			<img class="add-wait-animation-individual hideme" style="position: absolute; right: 0px; top: 0px;" src="${contextpath}/resources/images/ajax-loader.gif" />
		</div>
		
		<table id="individuals-table" class="table table-striped table-bordered" style="width: auto; margin-left: auto; margin-right: auto;">
			<c:forEach items="${form.survey.getQuestions()}" var="question">
				<c:choose>
					<c:when test="${question.getType() == 'Image' || question.getType() == 'Text' || question.getType() == 'Download' || question.getType() == 'Confirmation'}"></c:when>
					<c:when test="${question.getType() == 'GalleryQuestion' && !question.selection}"></c:when>
					<c:when test="${question.getType() == 'Upload' && publication != null && !publication.getShowUploadedDocuments()}"></c:when>
				
					<c:otherwise>
			
						<c:if test="${publication == null || publication.isAllQuestions() || publication.isSelected(question.id)}">
						
							<tr>
								<td>${question.title}</td>
									<c:choose>
										<c:when test="${question.getType() == 'Matrix'}">
											<td>
												<table class="table table-bordered">						
													<c:forEach items="${question.questions}" var="matrixQuestion">
														<tr>
															<td>${matrixQuestion.title}</td>										
															<c:set var="answers" value="${answerSet.getAnswers(matrixQuestion.id, matrixQuestion.uniqueId)}" />
															<c:if test="${answers.size() > 1}">
																<td class="questioncell" data-id="${matrixQuestion.id}">
																	<c:forEach items="${answers}" var="answer">					
																		${form.getAnswerTitle(answer)}<br />
																	</c:forEach>
																</td>
								 							</c:if>
															<c:if test="${answers.size() == 1}">
																<td class="questioncell" data-id="${matrixQuestion.id}" data-uid="${matrixQuestion.uniqueId}">${form.getAnswerTitle(answers.get(0))}</td>
															</c:if>
								 							<c:if test="${answers.size() < 1}">
																<td class="questioncell" data-id="${matrixQuestion.id}" data-uid="${matrixQuestion.uniqueId}">&#160;</td>
															</c:if>										
														</tr>
													</c:forEach>							
												</table>
											</td>
										</c:when>						
										<c:when test="${question.getType() == 'Table'}">
											<td>
												<table class="table table-bordered">						
													<c:forEach var="r" begin="1" end="${question.rows}"> 												
													<tr>							
														<c:forEach var="c" begin="1" end="${question.columns}"> 	
															<c:choose>
																<c:when test="${r == 1}">
																	<td>${question.childElements[c-1].title}</td>
																</c:when>
																<c:when test="${c == 1}">
																	<td>${question.childElements[question.columns + r - 2].title}</td>
																</c:when>
																<c:otherwise>
																	<td class="tablequestioncell" data-id="${question.id}" data-uid="${question.uniqueId}" data-row="${r-1}" data-column="${c-1}"><esapi:encodeForHTML>${answerSet.getTableAnswer(question, r-1, c-1, false)}</esapi:encodeForHTML></td>
																</c:otherwise>
															</c:choose>
														</c:forEach>
													</tr>
													</c:forEach>
												</table>		
											</td>				
										</c:when>
										<c:when test="${question.getType() == 'SingleChoiceQuestion' || question.getType() == 'MultipleChoiceQuestion'}">
											<td class="questioncell" data-id="${question.id}" data-uid="${question.uniqueId}">
												<c:set var="answers" value="${answerSet.getAnswers(question.id, question.uniqueId)}" />					
													<c:if test="${answers.size() > 1}">
														<c:forEach items="${answers}" var="answer">					
															${form.getAnswerTitle(answer)}<br />
														</c:forEach>
													</c:if>
													<c:if test="${answers.size() == 1}">${form.getAnswerTitle(answers.get(0))}</c:if>
						 							<c:if test="${answers.size() < 1}">&#160;</c:if>
											</td>
										</c:when>
										
										<c:when test="${question.getType() == 'RatingQuestion'}">
											<td>
												<table class="table table-bordered">						
													<c:forEach items="${question.questions}" var="childQuestion">	
														<tr>
															<td>${childQuestion.title}</td>										
															<c:set var="answers" value="${answerSet.getAnswers(childQuestion.id, childQuestion.uniqueId)}" />
															<c:if test="${answers.size() > 0}">
																<td class="questioncell" data-id="${childQuestion.id}">
																	${answers.get(0).getValue()}
																</td>
								 							</c:if>
															<c:if test="${answers.size() < 1}">
																<td class="questioncell" data-id="${childQuestion.id}" data-uid="${childQuestion.uniqueId}">&#160;</td>
															</c:if>										
														</tr>
													</c:forEach>							
												</table>
											</td>
										</c:when>
										
										<c:otherwise>
											<td class="questioncell" data-id="${question.id}" data-uid="${question.uniqueId}">
												<c:set var="answers" value="${answerSet.getAnswers(question.id, question.uniqueId)}" />					
												<c:choose>
													<c:when test="${question.getType() == 'Upload'}">
														<c:if test="${answers.size() > 0}">
															<c:forEach items="${answers}" var="answer">	
																<c:forEach items="${answer.files}" var="file">					
																	<a target="blank" href="${contextpath}/files/${file.uid}"><esapi:encodeForHTML>${file.name}</esapi:encodeForHTML></a><br />
																</c:forEach>
															</c:forEach>
														</c:if>
							 							<c:if test="${answers.size() < 1}">&#160;</c:if>
													</c:when>
													<c:when test="${question.getType() == 'GalleryQuestion'}">
														<c:if test="${answers.size() > 0}">
															<c:forEach items="${question.files}" var="file" varStatus="counter">
																<c:forEach items="${answers}" var="answer">	
																	<c:if test="${answer.value == counter.index.toString()}"><esapi:encodeForHTML>${file.name}</esapi:encodeForHTML><br />				
																	</c:if>
																</c:forEach>
															</c:forEach>
														</c:if>
							 							<c:if test="${answers.size() < 1}">&#160;</c:if>													
							 						</c:when>												
													<c:otherwise>
														<c:if test="${answers.size() > 1}">
															<c:forEach items="${answers}" var="answer">					
																<esapi:encodeForHTML>${form.getAnswerTitle(answer)}</esapi:encodeForHTML><br />
															</c:forEach>
														</c:if>
														<c:if test="${answers.size() == 1}"><esapi:encodeForHTML>${form.getAnswerTitle(answers.get(0))}</esapi:encodeForHTML></c:if>
							 							<c:if test="${answers.size() < 1}">&#160;</c:if>
													</c:otherwise>									
												</c:choose>
											</td>
										</c:otherwise>
									</c:choose>								
								</td>
							</tr>
						</c:if>
					</c:otherwise>
				</c:choose>		
			</c:forEach>
		</table>
		
		<div style="position: relative; margin-left: auto; margin-right: auto; text-align: center; width:350px; margin-bottom: 10px; margin-top: 10px;">
			<a data-toggle="tooltip" title="<spring:message code="label.GoToPreviousPage"/>" onclick="individualsMoveTo('previous', $(this).parent().parent());" class="widget-move-previous iconbutton disabled"><span class="glyphicon glyphicon-chevron-left"></span></a>				
			<span class="widget-first firstResultIndividual" style="margin-left: 10px; margin-right: 10px;">1</span>	
			<a data-toggle="tooltip" title="<spring:message code="label.GoToNextPage"/>" onclick="individualsMoveTo('next', $(this).parent().parent());" class="widget-move-next iconbutton"><span class="glyphicon glyphicon-chevron-right"></span></a>
			<img class="add-wait-animation-individual hideme" style="position: absolute; right: 0px; top: 0px;" src="${contextpath}/resources/images/ajax-loader.gif" />
		</div>
	</div>	

</div>
