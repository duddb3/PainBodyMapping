function imname = PDFtoPNG(filename)

    import org.apache.pdfbox.*
    import java.io.*

    if ~exist(filename,'file')
        fprintf(2,sprintf('Could not find input file: %s\n',strrep(filename,'\','\\')));
        return
    end
    [~,~,ext] = fileparts(filename);
    if ~strcmp(ext,'.pdf')
        fprintf(2,'Input file must be pdf\n');
        return
    end
    
    imname = strrep(filename,'.pdf','.png');
    
    jFile = File(filename);
    document = pdmodel.PDDocument.load(jFile);
    pdfRenderer = rendering.PDFRenderer(document);
    count = document.getNumberOfPages();
    if count>1
        fprintf(2,'Expected pdf to have 1 page. Attempting to write only the first page, but this has not been tested...\n')
    end
    bim = pdfRenderer.renderImageWithDPI(0, 300, rendering.ImageType.RGB);
    tools.imageio.ImageIOUtil.writeImage(bim,imname, 300);
    document.close()
end