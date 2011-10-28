<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Document - ${actionBean.dcIndex.title}">
	<stripes:layout-component name="contents">
			<!-- MAIN CONTENT -->
				<h1 class="documentFirstHeading">${actionBean.dcIndex.title}</h1>
				<div class="documentActions">
					<h5 class="hiddenStructure">${eunis:cmsPhrase(actionBean.contentManagement, 'Reference Actions')}</h5>
					<ul>
						<li>
							<a href="javascript:this.print();">
								<img
									src="http://webservices.eea.europa.eu/templates/print_icon.gif"
									alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}"
									title="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}" />
							</a>
						</li>
					</ul>
				</div>
				<br clear="all" />
				<div id="tabbedmenu">
                  <ul>
	              	<c:forEach items="${actionBean.tabsWithData }" var="dataTab">
              		<c:choose>
              			<c:when test="${dataTab.id eq actionBean.tab}">
	              			<li id="currenttab">
	              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}" 
	              				href="references/${actionBean.idref}/${dataTab.id}">${dataTab.value}</a>
	              			</li>
              			</c:when>
              			<c:otherwise>
              				<li>
	              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}"
	              				 href="references/${actionBean.idref}/${dataTab.id}">${dataTab.value}</a>
	              			</li>
              			</c:otherwise>
              		</c:choose>
              		</c:forEach>
                  </ul>
                </div>
                <br style="clear:both;" clear="all" />
                <br />
                <c:if test="${actionBean.tab == 'general'}">
	               	<%-- General information--%>
	                <h2>Reference information:</h2>
					<table width="90%" class="datatable">
						<col style="width:20%"/>
						<col style="width:80%"/>
						<tr>
							<th scope="row">Title</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.title)}</td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">Alternative title</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.alternative)}</td>
						</tr>
						<tr>
							<th scope="row">Source</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.source)}</td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">Editor</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.editor)}</td>
						</tr>
						<tr>
							<th scope="row">Journal Title</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.journalTitle)}</td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">Book Title</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.bookTitle)}</td>
						</tr>
						<tr>
							<th scope="row">Journal Issue</th>
							<td>${actionBean.dcIndex.journalIssue}</td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">ISBN</th>
							<td>${actionBean.dcIndex.isbn}</td>
						</tr>
						<tr>
							<th scope="row">URL</th>
							<td><a href="${eunis:replaceTags(actionBean.dcIndex.url)}">${eunis:replaceTags(actionBean.dcIndex.url)}</a></td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">Created</th>
							<td>${actionBean.dcIndex.created}</td>
						</tr>
						<tr>
							<th scope="row">Publisher</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.publisher)}</td>
						</tr>
						<c:if test="${!empty actionBean.dcAttributes}">
							<c:forEach items="${actionBean.dcAttributes}" var="attr" varStatus="loop">
								<tr ${loop.index % 2 != 0 ? '' : 'class="zebraeven"'}>
									<th scope="row">${actionBean.dcTermsLabels[attr.name]}</th>
									<c:choose>
				              			<c:when test="${attr.type == 'reference'}">
					              			<td><a href="${eunis:replaceTags(attr.value)}">${eunis:replaceTags(attr.value)}</a></td>
				              			</c:when>
				              			<c:otherwise>
				              				<td>${eunis:replaceTags(attr.value)}</td>
				              			</c:otherwise>
				              		</c:choose>
								</tr>
							</c:forEach>
						</c:if>
					</table>
	            </c:if>
	            <c:if test="${actionBean.tab == 'species'}">
	            	<h2>List of species scientific names related to this reference:</h2>
					<ol>
	            	<c:forEach items="${actionBean.species}" var="spe" varStatus="loop">
	            		<li style="background-color: ${loop.index % 2 == 0 ? '#FFFFFF' : '#EEEEEE'}">
                            <a href="species/${spe.key}">${spe.value}</a>
                        </li>
	            	</c:forEach>
					</ol>
	            </c:if>
	            <c:if test="${actionBean.tab == 'habitats'}">
	            	<h2>List of habitats related to this reference:</h2>
					<ol>
	            	<c:forEach items="${actionBean.habitats}" var="habitat" varStatus="loop">
	            		<li style="background-color: ${loop.index % 2 == 0 ? '#FFFFFF' : '#EEEEEE'}">
                            <a href="habitats/${habitat.key}">${habitat.value}</a>
                        </li>
	            	</c:forEach>
	            	</ol>
	            </c:if>

		<!-- END MAIN CONTENT -->
		</stripes:layout-component>
		<stripes:layout-component name="foot">
			<!-- start of the left (by default at least) column -->
				<div id="portal-column-one">
	            	<div class="visualPadding">
	              		<jsp:include page="/inc_column_left.jsp">
	                		<jsp:param name="page_name" value="references/${actionBean.idref}" />
	              		</jsp:include>
	            	</div>
	          	</div>
	          	<!-- end of the left (by default at least) column -->
		</stripes:layout-component>
</stripes:layout-render>