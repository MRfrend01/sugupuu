<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<html lang="et">
			<head>
				<meta charset="UTF-8"/>
				<title>Elizabeth II Sugupuu</title>
				<link rel="stylesheet" type="text/css" href="stiil.css"/>
			</head>
			<body>
				<h1>Elizabeth II ja tema järglased</h1>

				<!-- 1. Kõikide inimeste sünniaastad -->
				<div class="kast">
					<h2>1. Kõikide inimeste sünniaastad</h2>
					<p>
						<xsl:for-each select="//inimene">
							<b>
								<xsl:value-of select="@nimi"/>
							</b> (<xsl:value-of select="@sunniaasta"/>)<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
					</p>
				</div>

				<!-- 2. Inimesed, kellel on vähemalt 2 last -->
				<div class="kast">
					<h2>2. Inimesed, kellel on vähemalt kaks last</h2>
					<ul>
						<xsl:for-each select="//inimene[count(inimene) >= 2]">
							<li>
								<b>
									<xsl:value-of select="@nimi"/>
								</b> (lapsi: <xsl:value-of select="count(inimene)"/>)
							</li>
						</xsl:for-each>
					</ul>
				</div>

				<!-- 8. Otsinguvormid -->
				<div class="kast otsing">
					<h2>8. Otsing (Sümbolite ja nime pikkuse järgi)</h2>
					Otsi nime järgi: <input type="text" id="otsiNimi" onkeyup="filtreeri()"/>
					Maksimaalne nime pikkus: <input type="number" id="otsiPikkus" oninput="filtreeri()"/>
				</div>

				<!-- Tabel ülesannetega 3, 4, 5, 6, 7, 9, 10 -->
				<div class="kast">
					<h2>3–7, 9, 10. Sugupuu andmete tabel</h2>
					<table id="sugupuuTabel">
						<thead>
							<tr>
								<th>Nimi</th>
								<th>Sünniaasta</th>
								<th>Vanem</th>
								<th>Vanavanem</th>
								<th>Mitmendal vanema sünniaastal sündis</th>
								<th>Lapse vanus (järglasteta)</th>
								<th>Nime pikkus</th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="//inimene">
								<tr>
									<!-- 10. Alla 7 märgiga nimedele roheline taust -->
									<xsl:attribute name="class">
										<xsl:if test="string-length(@nimi) &lt; 7">lyhike-nimi</xsl:if>
									</xsl:attribute>

									<td>
										<b>
											<xsl:value-of select="@nimi"/>
										</b>
									</td>
									<td>
										<xsl:value-of select="@sunniaasta"/>
									</td>
									<td>
										<xsl:value-of select="../@nimi"/>
									</td>
									<td>
										<xsl:value-of select="../../@nimi"/>
									</td>

									<!-- 7. Mitmendal vanema sünniaastal sündis -->
									<td>
										<xsl:if test="../@sunniaasta">
											<xsl:value-of select="@sunniaasta - ../@sunniaasta"/> a.
										</xsl:if>
									</td>

									<!-- 6. Iga lapse vanus (kellel pole järglasi) -->
									<td>
										<xsl:if test="not(inimene)">
											<xsl:value-of select="2026 - @sunniaasta"/> a.
										</xsl:if>
									</td>

									<td>
										<xsl:value-of select="string-length(@nimi)"/> sümbolit
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>

				<!-- JavaScript otsimiseks -->
				<script>
					function filtreeri() {
					let nimi = document.getElementById("otsiNimi").value.toLowerCase();
					let pikkus = parseInt(document.getElementById("otsiPikkus").value);
					let read = document.getElementById("sugupuuTabel").getElementsByTagName("tr");

					for (let i = 1; i &lt; read.length; i++) {
					let nimeLahter = read[i].getElementsByTagName("td")[0];
					if (nimeLahter) {
					let tekst = nimeLahter.textContent || nimeLahter.innerText;
					let nimePikkus = tekst.length;

					let sobibNimi = tekst.toLowerCase().includes(nimi);
					let sobibPikkus = isNaN(pikkus) || nimePikkus &lt;= pikkus;

					read[i].style.display = (sobibNimi &amp;&amp; sobibPikkus) ? "" : "none";
					}
					}
					}
				</script>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>