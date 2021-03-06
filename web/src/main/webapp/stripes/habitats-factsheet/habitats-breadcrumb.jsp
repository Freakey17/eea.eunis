<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

    <div id="portal-breadcrumbs" class='species-taxonomy'>

        <span id="breadcrumbs-0" dir="ltr">
            <c:choose>
                <c:when test="${actionBean.factsheet.annexI}">
                    <a href="habitats-annex1-browser.jsp">Habitat Annex I Directive hierarchical view</a>
                </c:when>
                <c:when test="${actionBean.factsheet.eunis2017}">
                    <a href="habitats-code-browser-2017.jsp">EUNIS habitat classification 2017</a>
                </c:when>
                <c:otherwise>
                    <a href="habitats-code-browser.jsp">EUNIS habitat classification 2012</a>
                </c:otherwise>
            </c:choose>

            <span class="breadcrumbSeparator">
                &gt;
            </span>
        </span>

        <c:forEach items="${actionBean.factsheet.otherHabitatsRelations}" var="other" varStatus="loop">
            <span id="breadcrumbs-${loop.index + 1}" style="display: inline-block;" dir="ltr">
                <c:if test="${other.idHabitat != '10000'}">
                    <c:if test="${not empty other.eunisCode}">
                        ${other.eunisCode} -
                    </c:if>
                    <a href="habitats/${other.idHabitat}">${eunis:bracketsToItalics(eunis:replaceTags(other.scientificName))}</a>
                    <span class="breadcrumbSeparator">
                        &gt;
                    </span>
                </c:if>
            </span>
        </c:forEach>
        <span id="breadcrumbs-current" style="display: inline-block;" dir="ltr">
            <c:if test="${not empty actionBean.factsheet.eunisHabitatCode}">
                ${eunis:formatString(actionBean.factsheet.eunisHabitatCode, '')} -
            </c:if>
            ${eunis:bracketsToItalics(eunis:replaceTags(actionBean.factsheet.habitatScientificName))}
        </span>
    </div>

</stripes:layout-definition>