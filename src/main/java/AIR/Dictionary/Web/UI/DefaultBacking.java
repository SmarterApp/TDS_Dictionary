/*************************************************************************
 * Educational Online Test Delivery System Copyright (c) 2015 American
 * Institutes for Research
 * 
 * Distributed under the AIR Open Source License, Version 1.0 See accompanying
 * file AIR-License-1_0.txt or at
 * https://bitbucket.org/sbacoss/eotds/wiki/AIR_Open_Source_License
 *************************************************************************/

package AIR.Dictionary.Web.UI;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import AIR.Common.Web.BrowserOS;
import AIR.Common.Web.BrowserParser;
import AIR.Common.Web.WebHelper;

/**
 * @author mskhan
 * 
 */
@Component
@Scope ("prototype")
public class DefaultBacking
{
  String _dictionaryCode;
  String _accoms;
  String _group;
  String _audioSetting;  // "ogg" "wav" or "none";

  @PostConstruct
  protected void Page_Init ()
  {
    _dictionaryCode = WebHelper.getQueryString ("dictionary");
    _group = WebHelper.getQueryString ("group");

    String dict_opts = WebHelper.getQueryString ("do");
    String thes_opts = WebHelper.getQueryString ("to");
    String thes_select = WebHelper.getQueryString ("thesaurus");
    String spanish_select = WebHelper.getQueryString ("spanish");
    String spanish_opts = WebHelper.getQueryString ("so");

    String[] arr = new String[]
    {
        dict_opts,
        thes_opts,
        thes_select,
        spanish_select,
        spanish_opts
    };
    if(arr.length>0) {
    	_accoms = StringUtils.join (arr, ",");
    }

    determineAudio ();
  }

  private void determineAudio ()
  {
    String result = "none";
    BrowserParser bp = new BrowserParser ();

    if (bp.isSupportsOggAudio ())
    {
      result = "ogg";
    }
    else if (bp.getOsName () != BrowserOS.IOS)
    {
      result = "wav";
    }

    _audioSetting = result;
  }

  public String getAudioSetting ()
  {
    return _audioSetting;
  }

  public String getDictionaryCode ()
  {
    return _dictionaryCode;
  }

  public String getAccomsClasses ()
  {
    return _accoms;
  }

  public String getGroup ()
  {
    return _group;
  }
}
