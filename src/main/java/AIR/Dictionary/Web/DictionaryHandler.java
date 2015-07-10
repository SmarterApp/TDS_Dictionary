package AIR.Dictionary.Web;

import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import AIR.Common.Web.HttpHandlerBase;
import AIR.Dictionary.DictionaryConnectionMap;

@Controller
@Scope ("prototype")
public class DictionaryHandler extends HttpHandlerBase{
	
	private static final Logger _logger = LoggerFactory.getLogger(DictionaryHandler.class);
	
	@Autowired
	private DictionaryConnectionMap dm;
	
	@Override
	protected void onBeanFactoryInitialized() {
		
	}
	
	@RequestMapping (value = "/get_definitions", produces = "text/html;charset=UTF-8")
	@ResponseBody 
	public String getDefinitions(@RequestParam (value = "the_dict", required = false) String name,@RequestParam (value = "the_word", required = false)  String word,
			@RequestParam (value = "the_group", required = false)  String group,HttpServletResponse response) throws Exception
     {
         try
         {
        	 String result = dm.getDefHTML(name, word, group);
             return result;
         }
         catch (Exception ex)
         {
             
        	 _logger.error("Error in getDefinitions :: ",ex);
             if (ex.getMessage()!=null && ex.getMessage().equalsIgnoreCase("An error occurred while sending the request."))
             {
            	 response.sendError(HttpStatus.SC_SERVICE_UNAVAILABLE);
             }
             else
             {
            	 response.sendError(HttpStatus.SC_INTERNAL_SERVER_ERROR);
             }
             return null;
         }
     }
	
	
	@RequestMapping (value = "/get_thesaurus", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getThesaurus(@RequestParam (value = "the_word", required = false)  String word,
			@RequestParam (value = "the_group", required = false)  String group,HttpServletResponse response) throws Exception
     {
         try
         {
        	 String result = dm.getThesHTML( word, group);
             return result;
         }
         catch (Exception ex)
         {
             
        	 _logger.error("Error in getThesaurus :: ",ex);
             if (ex.getMessage()!=null && ex.getMessage().equalsIgnoreCase("An error occurred while sending the request."))
             {
            	 response.sendError(HttpStatus.SC_SERVICE_UNAVAILABLE);
             }
             else
             {
            	 response.sendError(HttpStatus.SC_INTERNAL_SERVER_ERROR);
             }
             return null;
         }
     }
	
	@RequestMapping (value = "/get_spanish", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getSpanish(@RequestParam (value = "the_word", required = false)  String word,
			@RequestParam (value = "the_group", required = false)  String group,HttpServletResponse response) throws Exception
     {
         try
         {
        	 String result = dm.getSpanishHTML( word, group);
             return result;
         }
         catch (Exception ex)
         {
             
        	 _logger.error("Error in getSpanish :: ",ex);
             if (ex.getMessage()!=null && ex.getMessage().equalsIgnoreCase("An error occurred while sending the request."))
             {
            	 response.sendError(HttpStatus.SC_SERVICE_UNAVAILABLE);
             }
             else
             {
            	 response.sendError(HttpStatus.SC_INTERNAL_SERVER_ERROR);
             }
             return null;
         }
     }
	
	@RequestMapping (value = "/get_audio")
	public void getAudio(@RequestParam (value = "filename", required = false)  String filename,
			@RequestParam (value = "type", required = false)  String type,HttpServletResponse response) throws Exception
     {
         
         //TODO mpatel Implement
//		AudioConnection ac = new AudioConnection(filename,type);
         /*for (Inout== audioStream = ac.getStream())
         {
             response.setContentType(ac.GetMapping());
             audioStream.CopyTo(CurrentContext.Response.OutputStream);
         }   */
     }
	

}
