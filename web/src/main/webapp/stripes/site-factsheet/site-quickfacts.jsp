<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet"%>
	<div class="right-area quickfacts">
		<h2>${eunis:cmsPhrase(actionBean.contentManagement, 'Quick facts')}</h2>
		<div>
            <p><span class="bold">${ actionBean.typeTitle } site</span> <span class="discreet">(code ${ actionBean.idsite })</span></p>

            <p>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Since')}
              <span class="bold">
                  <c:choose>
                   <c:when test="${not empty actionBean.siteDesignationDateDisplayValue}">
                        ${ (actionBean.siteDesignationDateDisplayValue) }
                   </c:when>
                   <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</c:otherwise>
                  </c:choose>
              </span>
            </p>
			<p>
			    ${eunis:cmsPhrase(actionBean.contentManagement, 'Country')}
                <span class="bold">
                    <c:choose>
                      <c:when test="${not empty actionBean.country}">${ (actionBean.country) }</c:when>
                      <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</c:otherwise>
                    </c:choose>
                </span>
            </p>
			<p>
			    ${eunis:cmsPhrase(actionBean.contentManagement, 'Region')}
			    <c:choose>
                <c:when test="${not empty actionBean.regionCode}">
                    <span class="bold">${ actionBean.regionName }</span> <span class="discreet">(${ actionBean.regionCode})<span></span>
			    </c:when>
			    <c:otherwise><span class="bold">${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</span></c:otherwise>
                </c:choose>
			</p>
            <p>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Surface area is')}
                <c:choose>
                    <c:when test="${not empty actionBean.surfaceAreaKm2}">
                        <span class="bold">${ actionBean.surfaceAreaKm2 } km<sup>2</sup></span> <span class="discreet">(${eunis:formatAreaExt(actionBean.factsheet.siteObject.area, 0, 2, '&nbsp;', null)} ha)</span>
                    </c:when>
                    <c:otherwise><span class="bold">${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</span></c:otherwise>
                 </c:choose>
            </p>

            <p>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Marine area is')}
                <span class="bold">
                    <c:choose>
                        <c:when test="${not empty actionBean.marineAreaPercentage}">
                            ${actionBean.marineAreaPercentage}%
                        </c:when>
                        <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</c:otherwise>
                    </c:choose>
                </span>
            </p>
            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'It is in the')} <span class="bold">
                <c:choose>
                <c:when test="${not empty actionBean.biogeographicRegion}">
                    <c:forEach items="${actionBean.biogeographicRegion}" var="bioregion" varStatus="loopStatus">
                        ${ bioregion }<c:if test="${!loopStatus.last}">, </c:if>
                    </c:forEach>
                 </c:when>
                 <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</c:otherwise>
                </c:choose>
              </span>
              <c:choose>
                <c:when test="${actionBean.biogeographicRegionsCount > 1}">${eunis:cmsPhrase(actionBean.contentManagement, 'biogeographical regions')}</c:when>
                <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'biogeographical region')}</c:otherwise>
              </c:choose>
            </p>

            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN management category')}
            <span class="bold">
                <c:choose>
                    <c:when test="${not empty actionBean.iucnCategory }">${ actionBean.iucnCategory }</c:when>
                    <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</c:otherwise>
                </c:choose>
            </span></p>
            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'It protects')} <span class="bold">${ (actionBean.habitatsCount) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'Nature Directives’ habitat types')}</p>
            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'It protects')} <span class="bold">${ (actionBean.protectedSpeciesCount) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'Nature Directives’ species')}</p>
<br>
			<c:if test="${ actionBean.typeNatura2000 }">
                <p class="discreet">${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}: <a href="http://natura2000.eea.europa.eu/Natura2000/SDF.aspx?site=${ actionBean.idsite }" target="_BLANK">Natura 2000 Standard Data Form</a></p>
				<input onclick="displayMoreResourcesSite();" id="more-resources" class="searchButton" type="button" value="Other resources">
				<div id="more-resources-container" class="more-resources-container" style="display: none;">
					<p><a href="http://natura2000.eea.europa.eu" target="_BLANK">Natura 2000 map viewer</a></p>
					<p><a href="http://www.protectedplanet.net" target="_BLANK">Protected planet map viewer</a></p>
					<p><a href="http://www.eea.europa.eu/data-and-maps/data/natura-3" target="_BLANK">Data download</a></p>
				</div>
            </c:if>
		</div>
	</div>
</stripes:layout-definition>