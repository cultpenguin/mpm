echo "1.3" > version.sgml

date > date.sgml

docbook2pdf --dsl mpm.dsl mpm.sgml
