<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" />
	
	<xsl:template match="/japicmp">
		<html>
			<head>
				<title>japicmp (oldJar: <xsl:value-of select="@oldJar"/>, newJar: <xsl:value-of select="@newJar"/>)</title>
				<style type="text/css">
                    body {
                        font-family: Verdana;
                    }
                    .title {
                        font-weight: bold;
                    }
					.new {
						color: green;
					}
					.removed {
						color: red;
					}
					.modified {
						color: orange;
					}
					.unchanged {
						color: black;
					}
					thead tr td {
                        font-weight: bold;
                    }
                    .toc {
                        margin-top: 1em;
                        margin-bottom: 1em;
                        border: 1px solid #dcdcdc;
                        padding: 5px;
                        background: #ededed;
                        display: inline-block;
                    }
                    table {
                        border-collapse: collapse;
                    }
                    table tr td {
                        border: 1px solid black;
                        padding: 5px;
                    }
                    table thead {
                        background-color: #dee3e9;
                    }
                    .class {
                        margin-bottom: 2em;
                        border: 1px solid #dcdcdc;
                        padding: 5px;
                        background: #ededed;
                        display: inline-block;
                    }
                    .class_superclass {
                        margin-top: 1em;
                    }
                    .class_interfaces {
                        margin-top: 1em;
                    }
                    .class_constructors {
                        margin-top: 1em;
                    }
                    .class_methods {
                        margin-top: 1em;
                    }
                    .class_annotations {
                        margin-top: 1em;
                    }
                    .label {
                        font-weight: bold;
                    }
                    .label_class_member {
                        background-color: #4d7a97;
                        display: inline-block;
                        padding: 5px;
                    }
                    .toc_link {
                        margin-left: 10px;
                        font-size: 0.5em;
                    }
                    .modifier {
                        font-style: italic;
                    }
                    ul {
                        list-style-type: none;
                        padding: 0px 0px;
                    }
				</style>
			</head>
			<body>
                <span class="title">JApiCmp-Report</span><br/>
                <span>old=<xsl:value-of select="@oldJar"/></span><br/>
                <span>new=<xsl:value-of select="@newJar"/></span><br/>
                <ul>
                    <xsl:if test="count(classes/class) > 0">
                        <li><a href="#toc">Classes</a></li>
                    </xsl:if>
                </ul>
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="classes">
		<div class="toc">
            <a name="toc"/>
            <span class="label">Classes:</span>
            <table>
                <thead>
                    <tr>
                        <td>Status</td>
                        <td>Fully Qualified Name</td>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="class" mode="toc"><xsl:sort select="@fullyQualifiedName"/></xsl:apply-templates>
                </tbody>
            </table>
		</div>
        <div>
            <xsl:apply-templates select="class" mode="detail"><xsl:sort select="@fullyQualifiedName"/></xsl:apply-templates>
        </div>
	</xsl:template>
	
	<xsl:template match="class" mode="toc">
        <tr>
            <td>
                <xsl:call-template name="outputChangeStatus"/>
            </td>
            <td>
                <a>
                    <xsl:attribute name="href">#<xsl:value-of select="@fullyQualifiedName"/></xsl:attribute>
                    <xsl:value-of select="@fullyQualifiedName" />
                </a>
            </td>
        </tr>
	</xsl:template>

    <xsl:template match="class" mode="detail">
        <div>
            <div class="class">
                <div class="class_header">
                    <span class="label">
                        <a>
                            <xsl:attribute name="name">
                                <xsl:value-of select="@fullyQualifiedName" />
                            </xsl:attribute>
                        </a>
                        <xsl:call-template name="outputChangeStatus"/>&#160;
                        <xsl:call-template name="modifiers"/>
                        <xsl:value-of select="translate(@type,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />&#160;
                        <xsl:value-of select="@fullyQualifiedName" />
                    </span>
                    <a href="#toc" class="toc_link">top</a>
                </div>
                <div class="class_superclass">
                    <xsl:if test="count(superclass) > 0 and (superclass/@superclassNew != 'n.a.' or superclass/@superclassOld != 'n.a.')">
                        <span class="label_class_member">Superclass:</span>
                        <table>
                            <thead>
                                <tr>
                                    <td>Status</td>
                                    <td>Superclass</td>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="superclass" />
                            </tbody>
                        </table>
                    </xsl:if>
                </div>
                <div class="class_interfaces">
                    <xsl:if test="count(interfaces/interface) > 0">
                        <span class="label_class_member">Interfaces:</span>
                        <table>
                            <thead>
                                <tr>
                                    <td>Status</td>
                                    <td>Interface</td>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="interfaces/interface"><xsl:sort select="@fullyQualifiedName"/></xsl:apply-templates>
                            </tbody>
                        </table>
                    </xsl:if>
                </div>
                <div class="class_fields">
                    <xsl:if test="count(fields/field) > 0">
                        <span class="label_class_member">Fields:</span>
                        <table>
                            <thead>
                                <tr>
                                    <td>Status</td>
                                    <td>Modifier</td>
                                    <td>Type</td>
                                    <td>Field</td>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="fields/field"><xsl:sort select="@name"/></xsl:apply-templates>
                            </tbody>
                        </table>
                    </xsl:if>
                </div>
                <div class="class_constructors">
                    <xsl:if test="count(constructors/constructor) > 0">
                        <span class="label_class_member">Constructors:</span>
                        <table>
                            <thead>
                                <tr>
                                    <td>Status</td>
                                    <td>Modifier</td>
                                    <td>Constructor</td>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="constructors/constructor"><xsl:sort select="@name"/></xsl:apply-templates>
                            </tbody>
                        </table>
                    </xsl:if>
                </div>
                <div class="class_methods">
                    <xsl:if test="count(methods/method) > 0">
                        <span class="label_class_member">Methods:</span>
                        <table>
                            <thead>
                                <tr>
                                    <td>Status</td>
                                    <td>Modifier</td>
                                    <td>Type</td>
                                    <td>Method</td>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="methods/method"><xsl:sort select="@name"/></xsl:apply-templates>
                            </tbody>
                        </table>
                    </xsl:if>
                </div>
                <xsl:call-template name="annotations"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="annotations">
        <xsl:if test="count(annotations/annotation) > 0">
            <div class="class_annotations">
                <span class="label_class_member">Annotations:</span>
                <table>
                    <thead>
                        <tr>
                            <td>Status:</td>
                            <td>Fully Qualified Name:</td>
                            <td>Elements:</td>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates select="annotations/annotation"><xsl:sort select="@fullyQualifiedName"/></xsl:apply-templates>
                    </tbody>
                </table>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="superclass">
        <tr>
            <td>
                <xsl:call-template name="outputChangeStatus"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="@changeStatus = 'NEW'">
                        <xsl:value-of select="@superclassNew"/>
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'REMOVED'">
                        <xsl:value-of select="@superclassOld"/>
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'MODIFIED'">
                        <xsl:value-of select="@superclassNew"/>(&lt;-&#160;<xsl:value-of select="@superclassOld"/>)
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'UNCHANGED'">
                        <xsl:value-of select="@superclassNew"/>
                    </xsl:when>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="interface">
        <tr>
            <td>
                <xsl:call-template name="outputChangeStatus"/>
            </td>
            <td>
                <xsl:value-of select="@fullyQualifiedName"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="field">
        <tr>
            <td>
                <xsl:call-template name="outputChangeStatus"/>
            </td>
            <td>
                <xsl:call-template name="modifiers"/>
            </td>
            <td>
                <xsl:call-template name="type"/>
            </td>
            <td>
                <xsl:value-of select="@name"/>
                <xsl:call-template name="annotations"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="constructor">
        <tr>
            <td>
                <xsl:call-template name="outputChangeStatus"/>
            </td>
            <td>
                <xsl:call-template name="modifiers"/>
            </td>
            <td>
                <xsl:value-of select="@name" />(<xsl:apply-templates select="parameters"/>)
                <xsl:call-template name="annotations"/>
            </td>
        </tr>
    </xsl:template>
	
	<xsl:template match="method">
		<tr>
            <td>
               <xsl:call-template name="outputChangeStatus"/>
			</td>
            <td>
                <xsl:call-template name="modifiers"/>
            </td>
            <td>
                <xsl:value-of select="@returnType" />
            </td>
            <td>
                <xsl:value-of select="@name" />(<xsl:apply-templates select="parameters"/>)
                <xsl:call-template name="annotations"/>
            </td>
        </tr>
	</xsl:template>

    <xsl:template match="annotation">
        <tr>
            <td>
                <xsl:call-template name="outputChangeStatus"/>
            </td>
            <td>
                <xsl:value-of select="@fullyQualifiedName" />
            </td>
            <td>
                <xsl:if test="count(elements/element) > 0">
                    <table>
                        <thead>
                            <tr>
                                <td>Status:</td>
                                <td>Name:</td>
                                <td>Old element values:</td>
                                <td>New element values:</td>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:apply-templates select="elements"/>
                        </tbody>
                    </table>
                </xsl:if>
                <xsl:if test="count(elements/element) = 0">n.a.</xsl:if>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="elements">
        <xsl:for-each select="element">
            <tr>
                <td>
                    <xsl:call-template name="outputChangeStatus"/>
                </td>
                <td>
                    <xsl:value-of select="@name"/>
                </td>
                <td>
                    <xsl:for-each select="oldElementValues/oldElementValue">
                        <xsl:if test="position() > 1">,</xsl:if>
                        <xsl:choose>
                            <xsl:when test="@type = 'Annotation'">
                                @<xsl:value-of select="@fullyQualifiedName"/>(<xsl:apply-templates select="values"/>)
                            </xsl:when>
                            <xsl:when test="@type = 'Array'">
                                {<xsl:apply-templates select="values"/>}
                            </xsl:when>
                            <xsl:when test="@type = 'Enum'">
                                <xsl:value-of select="@fullyQualifiedName"/>.<xsl:value-of select="@value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </td>
                <td>
                    <xsl:for-each select="newElementValues/newElementValue">
                        <xsl:if test="position() > 1">,</xsl:if>
                        <xsl:choose>
                            <xsl:when test="@type = 'Annotation'">
                                @<xsl:value-of select="@fullyQualifiedName"/>(<xsl:apply-templates select="values"/>)
                            </xsl:when>
                            <xsl:when test="@type = 'Array'">
                                {<xsl:apply-templates select="values"/>}
                            </xsl:when>
                            <xsl:when test="@type = 'Enum'">
                                <xsl:value-of select="@fullyQualifiedName"/>.<xsl:value-of select="@value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="values">
        <xsl:for-each select="value">
            <xsl:if test="position() > 1">,</xsl:if>
            <xsl:choose>
                <xsl:when test="@type = 'Annotation'">
                    @<xsl:value-of select="@fullyQualifiedName"/>(<xsl:apply-templates select="values"/>)
                </xsl:when>
                <xsl:when test="@type = 'Array'">
                    {<xsl:apply-templates select="values"/>}
                </xsl:when>
                <xsl:when test="@type = 'Enum'">
                    <xsl:value-of select="@fullyQualifiedName"/>.<xsl:value-of select="@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="parameters">
        <xsl:if test="count(parameter) > 0">
            <xsl:for-each select="parameter">
                <xsl:if test="position() > 1">,</xsl:if>
                <xsl:value-of select="@type"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template name="outputChangeStatus">
        <span>
            <xsl:choose>
                <xsl:when test="@changeStatus = 'MODIFIED'">
                    <xsl:attribute name="class">
                        modified
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@changeStatus = 'UNCHANGED'">
                    <xsl:attribute name="class">
                        unchanged
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@changeStatus = 'NEW'">
                    <xsl:attribute name="class">
                        new
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@changeStatus = 'REMOVED'">
                    <xsl:attribute name="class">
                        removed
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="@changeStatus" />
            <xsl:if test="@binaryCompatible = 'false'">
                (!)
            </xsl:if>
        </span>
    </xsl:template>

    <xsl:template name="modifiers">
        <xsl:for-each select="modifiers/modifier">
            <span>
                <xsl:choose>
                    <xsl:when test="@changeStatus = 'MODIFIED'">
                        <xsl:attribute name="class">
                            modified modifier
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'UNCHANGED'">
                        <xsl:attribute name="class">
                            unchanged modifier
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'NEW'">
                        <xsl:attribute name="class">
                            new modifier
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'REMOVED'">
                        <xsl:attribute name="class">
                            removed modifier
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="@changeStatus = 'MODIFIED'">
                        <xsl:call-template name="modifier"><xsl:with-param name="modifier" select="@newValue"/><xsl:with-param
                                name="changeStatus" select="@changeStatus"/></xsl:call-template>&#160;(&lt;-&#160;<xsl:call-template name="modifier"><xsl:with-param name="modifier" select="@oldValue"/><xsl:with-param
                            name="changeStatus" select="@changeStatus"/></xsl:call-template>)&#160;
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'UNCHANGED'">
                        <xsl:call-template name="modifier"><xsl:with-param name="modifier" select="@newValue"/><xsl:with-param
                                name="changeStatus" select="@changeStatus"/></xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'NEW'">
                        <xsl:call-template name="modifier"><xsl:with-param name="modifier" select="@newValue"/><xsl:with-param
                                name="changeStatus" select="@changeStatus"/></xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@changeStatus = 'REMOVED'">
                        <xsl:call-template name="modifier"><xsl:with-param name="modifier" select="@oldValue"/><xsl:with-param
                                name="changeStatus" select="@changeStatus"/></xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </span>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="modifier">
        <xsl:param name="modifier"/>
        <xsl:param name="changeStatus"/>
        <xsl:choose>
            <xsl:when test="$modifier = 'NON_FINAL'"><xsl:if test="$changeStatus = 'MODIFIED'">not_final</xsl:if></xsl:when>
            <xsl:when test="$modifier = 'NON_STATIC'"><xsl:if test="$changeStatus = 'MODIFIED'">not_static</xsl:if></xsl:when>
            <xsl:when test="$modifier = 'NON_ABSTRACT'"><xsl:if test="$changeStatus = 'MODIFIED'">not_abstract</xsl:if></xsl:when>
            <xsl:when test="$modifier = 'PACKAGE_PROTECTED'"><xsl:if test="$changeStatus = 'MODIFIED'">package_protected</xsl:if></xsl:when>
            <xsl:otherwise><xsl:value-of select="translate($modifier, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" /><xsl:if test="$changeStatus != 'MODIFIED'">&#160;</xsl:if></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="type">
        <span>
            <xsl:choose>
                <xsl:when test="@changeStatus = 'MODIFIED'">
                    <xsl:attribute name="class">
                        modified modifier
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@changeStatus = 'UNCHANGED'">
                    <xsl:attribute name="class">
                        unchanged modifier
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@changeStatus = 'NEW'">
                    <xsl:attribute name="class">
                        new modifier
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@changeStatus = 'REMOVED'">
                    <xsl:attribute name="class">
                        removed modifier
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="type/@changeStatus = 'MODIFIED'">
                    <xsl:value-of select="type/@newValue"/>&#160;(&lt;-&#160;<xsl:value-of select="type/@oldValue"/>)
                </xsl:when>
                <xsl:when test="type/@changeStatus = 'UNCHANGED'">
                    <xsl:value-of select="type/@newValue"/>
                </xsl:when>
                <xsl:when test="type/@changeStatus = 'NEW'">
                    <xsl:value-of select="type/@newValue"/>
                </xsl:when>
                <xsl:when test="type/@changeStatus = 'REMOVED'">
                    <xsl:value-of select="type/@oldValue"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@binaryCompatible = 'false'">
                (!)
            </xsl:if>
        </span>
    </xsl:template>
</xsl:stylesheet>