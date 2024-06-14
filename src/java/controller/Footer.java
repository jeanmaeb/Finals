/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.ColumnText;

public class Footer extends PdfPageEventHelper {
    private Font footerFont = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD);

    @Override
    public void onEndPage(PdfWriter writer, Document document) {
        Phrase footer = new Phrase("Thank You for Purchasing!!! Please Come Again", footerFont);
        ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_CENTER, footer,
                (document.right() - document.left()) / 2 + document.leftMargin(), document.bottom() - 10, 0);
    }
}
