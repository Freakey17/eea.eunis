<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <div>
        <c:if test="${not empty actionBean.englishDescription}">
            <h4>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Description')} (English)
            </h4>
            <p>
                ${eunis:treatLineEndings(eunis:bracketsToItalics(eunis:treatURLSpecialCharacters(actionBean.englishDescription)))}
            </p>
        </c:if>

    <c:choose>
        <c:when test="${actionBean.factsheet.annexI}">
            <span class="discreet">
            <c:forEach items="${actionBean.descriptions}" var="desc" varStatus="loop">
                <c:if test="${!empty desc.idDc && idDc != -1}">
                    <c:set var="ssource" value="${eunis:execMethodParamInteger('ro.finsiel.eunis.factsheet.species.SpeciesFactsheet', 'getBookAuthorDate', desc.idDc)}"/>
                    <c:if test="${!empty ssource}">
                        <p>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}:
                            <a href="references/${desc.idDc}">${eunis:treatURLSpecialCharacters(ssource)}</a>
                        </p>
                    </c:if>
                </c:if>
            </c:forEach>
            </span>
        </c:when>
        <c:otherwise>
            <p>
                <span class="discreet">
                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}:
                    <a href="http://www.eea.europa.eu/data-and-maps/data/eunis-habitat-classification">EUNIS habitat classification</a>
                </span>
            </p>
        </c:otherwise>
    </c:choose>
    </div>
</stripes:layout-definition>