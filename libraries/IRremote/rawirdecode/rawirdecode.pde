


<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
        <title>rawirdecode.pde at master from adafruit/Raw-IR-decoder-for-Arduino - GitHub</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />

    
    

    <meta content="authenticity_token" name="csrf-param" />
<meta content="rxp/9saNxNobf78zsmAICvnLS/ng3bO/8aVZypdOGuw=" name="csrf-token" />

    <link href="https://a248.e.akamai.net/assets.github.com/stylesheets/bundles/github-bb736474f868002a5f8859e0916beb9760d40ca7.css" media="screen" rel="stylesheet" type="text/css" />
    

    <script src="https://a248.e.akamai.net/assets.github.com/javascripts/bundles/jquery-6c2aad85e5c2becfaac6d62ce0f290d10fa1725e.js" type="text/javascript"></script>
    <script src="https://a248.e.akamai.net/assets.github.com/javascripts/bundles/github-5955ca4b60d66931577d3bd49ffb3681ef7f9db7.js" type="text/javascript"></script>
    

      <link rel='permalink' href='/adafruit/Raw-IR-decoder-for-Arduino/blob/9914e3436547e1f0375a8f7453e7d1fa52660569/rawirdecode.pde'>

    <meta name="description" content="Raw-IR-decoder-for-Arduino - Take raw IR signal from a remote receiver and print out pulse lengths" />
  <link href="https://github.com/adafruit/Raw-IR-decoder-for-Arduino/commits/master.atom" rel="alternate" title="Recent Commits to Raw-IR-decoder-for-Arduino:master" type="application/atom+xml" />

  </head>


  <body class="logged_out page-blob   env-production ">
    


    

      <div id="header" class="true clearfix">
        <div class="container clearfix">
          <a class="site-logo" href="https://github.com">
            <!--[if IE]>
            <img alt="GitHub" class="github-logo" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov7.png?1323882799" />
            <img alt="GitHub" class="github-logo-hover" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov7-hover.png?1324325436" />
            <![endif]-->
            <img alt="GitHub" class="github-logo-4x" height="30" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov7@4x.png?1323882799" />
            <img alt="GitHub" class="github-logo-4x-hover" height="30" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov7@4x-hover.png?1324325436" />
          </a>

                  <!--
      make sure to use fully qualified URLs here since this nav
      is used on error pages on other domains
    -->
    <ul class="top-nav logged_out">
        <li class="pricing"><a href="https://github.com/plans">Signup and Pricing</a></li>
        <li class="explore"><a href="https://github.com/explore">Explore GitHub</a></li>
      <li class="features"><a href="https://github.com/features">Features</a></li>
        <li class="blog"><a href="https://github.com/blog">Blog</a></li>
      <li class="login"><a href="https://github.com/login?return_to=%2Fadafruit%2FRaw-IR-decoder-for-Arduino%2Fblob%2Fmaster%2Frawirdecode.pde">Login</a></li>
    </ul>



          
        </div>
      </div>

      

            <div class="site">
      <div class="container">
        <div class="pagehead repohead instapaper_ignore readability-menu">


        <div class="title-actions-bar">
          <h1>
            <a href="/adafruit">adafruit</a> /
            <strong><a href="/adafruit/Raw-IR-decoder-for-Arduino" class="js-current-repository">Raw-IR-decoder-for-Arduino</a></strong>
          </h1>
          



              <ul class="pagehead-actions">


          <li><a href="/login?return_to=%2Fadafruit%2FRaw-IR-decoder-for-Arduino" class="minibutton btn-watch watch-button entice tooltipped leftwards" rel="nofollow" title="You must be logged in to use this feature"><span><span class="icon"></span>Watch</span></a></li>
          <li><a href="/login?return_to=%2Fadafruit%2FRaw-IR-decoder-for-Arduino" class="minibutton btn-fork fork-button entice tooltipped leftwards" rel="nofollow" title="You must be logged in to use this feature"><span><span class="icon"></span>Fork</span></a></li>


      <li class="repostats">
        <ul class="repo-stats">
          <li class="watchers ">
            <a href="/adafruit/Raw-IR-decoder-for-Arduino/watchers" title="Watchers" class="tooltipped downwards">
              11
            </a>
          </li>
          <li class="forks">
            <a href="/adafruit/Raw-IR-decoder-for-Arduino/network" title="Forks" class="tooltipped downwards">
              3
            </a>
          </li>
        </ul>
      </li>
    </ul>

        </div>

          

  <ul class="tabs">
    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino" class="selected" highlight="repo_sourcerepo_downloadsrepo_commitsrepo_tagsrepo_branches">Code</a></li>
    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/network" highlight="repo_networkrepo_fork_queue">Network</a>
    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/pulls" highlight="repo_pulls">Pull Requests <span class='counter'>0</span></a></li>

      <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/issues" highlight="repo_issues">Issues <span class='counter'>0</span></a></li>


    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/graphs" highlight="repo_graphsrepo_contributors">Stats &amp; Graphs</a></li>

  </ul>

  
<div class="frame frame-center tree-finder" style="display:none"
      data-tree-list-url="/adafruit/Raw-IR-decoder-for-Arduino/tree-list/9914e3436547e1f0375a8f7453e7d1fa52660569"
      data-blob-url-prefix="/adafruit/Raw-IR-decoder-for-Arduino/blob/9914e3436547e1f0375a8f7453e7d1fa52660569"
    >

  <div class="breadcrumb">
    <b><a href="/adafruit/Raw-IR-decoder-for-Arduino">Raw-IR-decoder-for-Arduino</a></b> /
    <input class="tree-finder-input js-navigation-enable" type="text" name="query" autocomplete="off" spellcheck="false">
  </div>

    <div class="octotip">
      <p>
        <a href="/adafruit/Raw-IR-decoder-for-Arduino/dismiss-tree-finder-help" class="dismiss js-dismiss-tree-list-help" title="Hide this notice forever" rel="nofollow">Dismiss</a>
        <strong>Octotip:</strong> You've activated the <em>file finder</em>
        by pressing <span class="kbd">t</span> Start typing to filter the
        file list. Use <span class="kbd badmono">↑</span> and
        <span class="kbd badmono">↓</span> to navigate,
        <span class="kbd">enter</span> to view files.
      </p>
    </div>

  <table class="tree-browser" cellpadding="0" cellspacing="0">
    <tr class="js-header"><th>&nbsp;</th><th>name</th></tr>
    <tr class="js-no-results no-results" style="display: none">
      <th colspan="2">No matching files</th>
    </tr>
    <tbody class="js-results-list js-navigation-container" data-navigation-enable-mouse>
    </tbody>
  </table>
</div>

<div id="jump-to-line" style="display:none">
  <h2>Jump to Line</h2>
  <form>
    <input class="textfield" type="text">
    <div class="full-button">
      <button type="submit" class="classy">
        <span>Go</span>
      </button>
    </div>
  </form>
</div>


<div class="subnav-bar">

  <ul class="actions">
    
      <li class="switcher">

        <div class="context-menu-container js-menu-container">
          <span class="text">Current branch:</span>
          <a href="#"
             class="minibutton bigger switcher context-menu-button js-menu-target js-commitish-button btn-branch repo-tree"
             data-master-branch="master"
             data-ref="master">
            <span><span class="icon"></span>master</span>
          </a>

          <div class="context-pane commitish-context js-menu-content">
            <a href="javascript:;" class="close js-menu-close"></a>
            <div class="title">Switch Branches/Tags</div>
            <div class="body pane-selector commitish-selector js-filterable-commitishes">
              <div class="filterbar">
                <div class="placeholder-field js-placeholder-field">
                  <label class="placeholder" for="context-commitish-filter-field" data-placeholder-mode="sticky">Filter branches/tags</label>
                  <input type="text" id="context-commitish-filter-field" class="commitish-filter" />
                </div>

                <ul class="tabs">
                  <li><a href="#" data-filter="branches" class="selected">Branches</a></li>
                  <li><a href="#" data-filter="tags">Tags</a></li>
                </ul>
              </div>

                <div class="commitish-item branch-commitish selector-item">
                  <h4>
                      <a href="/adafruit/Raw-IR-decoder-for-Arduino/blob/master/rawirdecode.pde" data-name="master" rel="nofollow">master</a>
                  </h4>
                </div>


              <div class="no-results" style="display:none">Nothing to show</div>
            </div>
          </div><!-- /.commitish-context-context -->
        </div>

      </li>
  </ul>

  <ul class="subnav">
    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino" class="selected" highlight="repo_source">Files</a></li>
    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/commits/master" highlight="repo_commits">Commits</a></li>
    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/branches" class="" highlight="repo_branches" rel="nofollow">Branches <span class="counter">1</span></a></li>
    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/tags" class="blank" highlight="repo_tags">Tags <span class="counter">0</span></a></li>
    <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/downloads" class="blank" highlight="repo_downloads">Downloads <span class="counter">0</span></a></li>
  </ul>

</div>

  
  
  


          

        </div><!-- /.repohead -->

        




  
  <p class="last-commit">Latest commit to the <strong>master</strong> branch</p>

<div class="commit commit-tease js-details-container">
  <p class="commit-title ">
      <a href="/adafruit/Raw-IR-decoder-for-Arduino/commit/9914e3436547e1f0375a8f7453e7d1fa52660569" class="message">Added Array printing</a>
      
  </p>
  <div class="commit-meta">
    <a href="/adafruit/Raw-IR-decoder-for-Arduino/commit/9914e3436547e1f0375a8f7453e7d1fa52660569" class="sha-block">commit <span class="sha">9914e34365</span></a>

    <div class="authorship">
      <img class="gravatar" height="20" src="https://secure.gravatar.com/avatar/3f7ca151e1f7f7dead8b2db60aa744c1?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png" width="20" />
      <span class="author-name"><a href="/ladyada">ladyada</a></span>
      authored <time class="js-relative-date" datetime="2010-10-05T18:48:25-07:00" title="2010-10-05 18:48:25">October 05, 2010</time>

    </div>
  </div>
</div>


<!-- block_view_fragment_key: views4/v8/blob:v15:964353:adafruit/Raw-IR-decoder-for-Arduino:31753177a28497c184dd9f08df94c6c914a9e36c:8fd7cb6b6b84fdc8a8b3c58c8563df75 -->
  <div id="slider">

    <div class="breadcrumb" data-path="rawirdecode.pde/">
      <b><a href="/adafruit/Raw-IR-decoder-for-Arduino/tree/9914e3436547e1f0375a8f7453e7d1fa52660569" class="js-rewrite-sha">Raw-IR-decoder-for-Arduino</a></b> / rawirdecode.pde       <span style="display:none" id="clippy_861" class="clippy-text">rawirdecode.pde</span>
      
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="14"
              class="clippy"
              id="clippy" >
      <param name="movie" value="https://a248.e.akamai.net/assets.github.com/flash/clippy.swf?1284681402?v5"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param NAME="FlashVars" value="id=clippy_861&amp;copied=copied!&amp;copyto=copy to clipboard">
      <param name="bgcolor" value="#FFFFFF">
      <param name="wmode" value="opaque">
      <embed src="https://a248.e.akamai.net/assets.github.com/flash/clippy.swf?1284681402?v5"
             width="110"
             height="14"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars="id=clippy_861&amp;copied=copied!&amp;copyto=copy to clipboard"
             bgcolor="#FFFFFF"
             wmode="opaque"
      />
      </object>
      

    </div>

    <div class="frames">
      <div class="frame frame-center" data-path="rawirdecode.pde/" data-permalink-url="/adafruit/Raw-IR-decoder-for-Arduino/blob/9914e3436547e1f0375a8f7453e7d1fa52660569/rawirdecode.pde" data-title="rawirdecode.pde at master from adafruit/Raw-IR-decoder-for-Arduino - GitHub" data-type="blob">
          <ul class="big-actions">
            <li><a class="file-edit-link minibutton js-rewrite-sha" href="/adafruit/Raw-IR-decoder-for-Arduino/edit/9914e3436547e1f0375a8f7453e7d1fa52660569/rawirdecode.pde" data-method="post" rel="nofollow"><span>Edit this file</span></a></li>
          </ul>

        <div id="files">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><img alt="Txt" height="16" src="https://a248.e.akamai.net/assets.github.com/images/icons/txt.png?1284681402" width="16" /></span>
                <span class="mode" title="File Mode">100644</span>
                  <span>104 lines (87 sloc)</span>
                <span>3.12 kb</span>
              </div>
              <ul class="actions">
                <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/raw/master/rawirdecode.pde" id="raw-url">raw</a></li>
                  <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/blame/master/rawirdecode.pde">blame</a></li>
                <li><a href="/adafruit/Raw-IR-decoder-for-Arduino/commits/master/rawirdecode.pde" rel="nofollow">history</a></li>
              </ul>
            </div>
              <div class="data type-java">
      <table cellpadding="0" cellspacing="0" class="lines">
        <tr>
          <td>
            <pre class="line_numbers"><span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
</pre>
          </td>
          <td width="100%">
                <div class="highlight"><pre><div class='line' id='LC1'><span class="cm">/* Raw IR decoder sketch!</span></div><div class='line' id='LC2'><span class="cm"> </span></div><div class='line' id='LC3'><span class="cm"> This sketch/program uses the Arduno and a PNA4602 to </span></div><div class='line' id='LC4'><span class="cm"> decode IR received. This can be used to make a IR receiver</span></div><div class='line' id='LC5'><span class="cm"> (by looking for a particular code)</span></div><div class='line' id='LC6'><span class="cm"> or transmitter (by pulsing an IR LED at ~38KHz for the</span></div><div class='line' id='LC7'><span class="cm"> durations detected </span></div><div class='line' id='LC8'><span class="cm"> </span></div><div class='line' id='LC9'><span class="cm"> Code is public domain, check out www.ladyada.net and adafruit.com</span></div><div class='line' id='LC10'><span class="cm"> for more tutorials! </span></div><div class='line' id='LC11'><span class="cm"> */</span></div><div class='line' id='LC12'><br/></div><div class='line' id='LC13'><span class="c1">// We need to use the &#39;raw&#39; pin reading methods</span></div><div class='line' id='LC14'><span class="c1">// because timing is very important here and the digitalRead()</span></div><div class='line' id='LC15'><span class="c1">// procedure is slower!</span></div><div class='line' id='LC16'><span class="c1">//uint8_t IRpin = 2;</span></div><div class='line' id='LC17'><span class="c1">// Digital pin #2 is the same as Pin D2 see</span></div><div class='line' id='LC18'><span class="c1">// http://arduino.cc/en/Hacking/PinMapping168 for the &#39;raw&#39; pin mapping</span></div><div class='line' id='LC19'><span class="err">#</span><span class="n">define</span> <span class="n">IRpin_PIN</span>      <span class="n">PIND</span></div><div class='line' id='LC20'><span class="err">#</span><span class="n">define</span> <span class="n">IRpin</span>          <span class="mi">2</span></div><div class='line' id='LC21'><br/></div><div class='line' id='LC22'><span class="c1">// the maximum pulse we&#39;ll listen for - 65 milliseconds is a long time</span></div><div class='line' id='LC23'><span class="err">#</span><span class="n">define</span> <span class="n">MAXPULSE</span> <span class="mi">65000</span></div><div class='line' id='LC24'><br/></div><div class='line' id='LC25'><span class="c1">// what our timing resolution should be, larger is better</span></div><div class='line' id='LC26'><span class="c1">// as its more &#39;precise&#39; - but too large and you wont get</span></div><div class='line' id='LC27'><span class="c1">// accurate timing</span></div><div class='line' id='LC28'><span class="err">#</span><span class="n">define</span> <span class="n">RESOLUTION</span> <span class="mi">20</span> </div><div class='line' id='LC29'><br/></div><div class='line' id='LC30'><span class="c1">// we will store up to 100 pulse pairs (this is -a lot-)</span></div><div class='line' id='LC31'><span class="n">uint16_t</span> <span class="n">pulses</span><span class="o">[</span><span class="mi">100</span><span class="o">][</span><span class="mi">2</span><span class="o">];</span>  <span class="c1">// pair is high and low pulse </span></div><div class='line' id='LC32'><span class="n">uint8_t</span> <span class="n">currentpulse</span> <span class="o">=</span> <span class="mi">0</span><span class="o">;</span> <span class="c1">// index for pulses we&#39;re storing</span></div><div class='line' id='LC33'><br/></div><div class='line' id='LC34'><span class="kt">void</span> <span class="nf">setup</span><span class="o">(</span><span class="kt">void</span><span class="o">)</span> <span class="o">{</span></div><div class='line' id='LC35'>&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">begin</span><span class="o">(</span><span class="mi">9600</span><span class="o">);</span></div><div class='line' id='LC36'>&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">println</span><span class="o">(</span><span class="s">&quot;Ready to decode IR!&quot;</span><span class="o">);</span></div><div class='line' id='LC37'><span class="o">}</span></div><div class='line' id='LC38'><br/></div><div class='line' id='LC39'><span class="kt">void</span> <span class="nf">loop</span><span class="o">(</span><span class="kt">void</span><span class="o">)</span> <span class="o">{</span></div><div class='line' id='LC40'>&nbsp;&nbsp;<span class="n">uint16_t</span> <span class="n">highpulse</span><span class="o">,</span> <span class="n">lowpulse</span><span class="o">;</span>  <span class="c1">// temporary storage timing</span></div><div class='line' id='LC41'>&nbsp;&nbsp;<span class="n">highpulse</span> <span class="o">=</span> <span class="n">lowpulse</span> <span class="o">=</span> <span class="mi">0</span><span class="o">;</span> <span class="c1">// start out with no pulse length</span></div><div class='line' id='LC42'>&nbsp;&nbsp;</div><div class='line' id='LC43'>&nbsp;&nbsp;</div><div class='line' id='LC44'><span class="c1">//  while (digitalRead(IRpin)) { // this is too slow!</span></div><div class='line' id='LC45'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">while</span> <span class="o">(</span><span class="n">IRpin_PIN</span> <span class="o">&amp;</span> <span class="o">(</span><span class="mi">1</span> <span class="o">&lt;&lt;</span> <span class="n">IRpin</span><span class="o">))</span> <span class="o">{</span></div><div class='line' id='LC46'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// pin is still HIGH</span></div><div class='line' id='LC47'><br/></div><div class='line' id='LC48'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// count off another few microseconds</span></div><div class='line' id='LC49'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">highpulse</span><span class="o">++;</span></div><div class='line' id='LC50'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">delayMicroseconds</span><span class="o">(</span><span class="n">RESOLUTION</span><span class="o">);</span></div><div class='line' id='LC51'><br/></div><div class='line' id='LC52'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// If the pulse is too long, we &#39;timed out&#39; - either nothing</span></div><div class='line' id='LC53'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// was received or the code is finished, so print what</span></div><div class='line' id='LC54'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// we&#39;ve grabbed so far, and then reset</span></div><div class='line' id='LC55'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">((</span><span class="n">highpulse</span> <span class="o">&gt;=</span> <span class="n">MAXPULSE</span><span class="o">)</span> <span class="o">&amp;&amp;</span> <span class="o">(</span><span class="n">currentpulse</span> <span class="o">!=</span> <span class="mi">0</span><span class="o">))</span> <span class="o">{</span></div><div class='line' id='LC56'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">printpulses</span><span class="o">();</span></div><div class='line' id='LC57'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">currentpulse</span><span class="o">=</span><span class="mi">0</span><span class="o">;</span></div><div class='line' id='LC58'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span><span class="o">;</span></div><div class='line' id='LC59'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="o">}</span></div><div class='line' id='LC60'>&nbsp;&nbsp;<span class="o">}</span></div><div class='line' id='LC61'>&nbsp;&nbsp;<span class="c1">// we didn&#39;t time out so lets stash the reading</span></div><div class='line' id='LC62'>&nbsp;&nbsp;<span class="n">pulses</span><span class="o">[</span><span class="n">currentpulse</span><span class="o">][</span><span class="mi">0</span><span class="o">]</span> <span class="o">=</span> <span class="n">highpulse</span><span class="o">;</span></div><div class='line' id='LC63'>&nbsp;&nbsp;</div><div class='line' id='LC64'>&nbsp;&nbsp;<span class="c1">// same as above</span></div><div class='line' id='LC65'>&nbsp;&nbsp;<span class="k">while</span> <span class="o">(!</span> <span class="o">(</span><span class="n">IRpin_PIN</span> <span class="o">&amp;</span> <span class="n">_BV</span><span class="o">(</span><span class="n">IRpin</span><span class="o">)))</span> <span class="o">{</span></div><div class='line' id='LC66'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// pin is still LOW</span></div><div class='line' id='LC67'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">lowpulse</span><span class="o">++;</span></div><div class='line' id='LC68'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">delayMicroseconds</span><span class="o">(</span><span class="n">RESOLUTION</span><span class="o">);</span></div><div class='line' id='LC69'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="o">((</span><span class="n">lowpulse</span> <span class="o">&gt;=</span> <span class="n">MAXPULSE</span><span class="o">)</span>  <span class="o">&amp;&amp;</span> <span class="o">(</span><span class="n">currentpulse</span> <span class="o">!=</span> <span class="mi">0</span><span class="o">))</span> <span class="o">{</span></div><div class='line' id='LC70'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">printpulses</span><span class="o">();</span></div><div class='line' id='LC71'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">currentpulse</span><span class="o">=</span><span class="mi">0</span><span class="o">;</span></div><div class='line' id='LC72'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span><span class="o">;</span></div><div class='line' id='LC73'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="o">}</span></div><div class='line' id='LC74'>&nbsp;&nbsp;<span class="o">}</span></div><div class='line' id='LC75'>&nbsp;&nbsp;<span class="n">pulses</span><span class="o">[</span><span class="n">currentpulse</span><span class="o">][</span><span class="mi">1</span><span class="o">]</span> <span class="o">=</span> <span class="n">lowpulse</span><span class="o">;</span></div><div class='line' id='LC76'><br/></div><div class='line' id='LC77'>&nbsp;&nbsp;<span class="c1">// we read one high-low pulse successfully, continue!</span></div><div class='line' id='LC78'>&nbsp;&nbsp;<span class="n">currentpulse</span><span class="o">++;</span></div><div class='line' id='LC79'><span class="o">}</span></div><div class='line' id='LC80'><br/></div><div class='line' id='LC81'><span class="kt">void</span> <span class="nf">printpulses</span><span class="o">(</span><span class="kt">void</span><span class="o">)</span> <span class="o">{</span></div><div class='line' id='LC82'>&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">println</span><span class="o">(</span><span class="s">&quot;\n\r\n\rReceived: \n\rOFF \tON&quot;</span><span class="o">);</span></div><div class='line' id='LC83'>&nbsp;&nbsp;<span class="k">for</span> <span class="o">(</span><span class="n">uint8_t</span> <span class="n">i</span> <span class="o">=</span> <span class="mi">0</span><span class="o">;</span> <span class="n">i</span> <span class="o">&lt;</span> <span class="n">currentpulse</span><span class="o">;</span> <span class="n">i</span><span class="o">++)</span> <span class="o">{</span></div><div class='line' id='LC84'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="n">pulses</span><span class="o">[</span><span class="n">i</span><span class="o">][</span><span class="mi">0</span><span class="o">]</span> <span class="o">*</span> <span class="n">RESOLUTION</span><span class="o">,</span> <span class="n">DEC</span><span class="o">);</span></div><div class='line' id='LC85'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="s">&quot; usec, &quot;</span><span class="o">);</span></div><div class='line' id='LC86'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="n">pulses</span><span class="o">[</span><span class="n">i</span><span class="o">][</span><span class="mi">1</span><span class="o">]</span> <span class="o">*</span> <span class="n">RESOLUTION</span><span class="o">,</span> <span class="n">DEC</span><span class="o">);</span></div><div class='line' id='LC87'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">println</span><span class="o">(</span><span class="s">&quot; usec&quot;</span><span class="o">);</span></div><div class='line' id='LC88'>&nbsp;&nbsp;<span class="o">}</span></div><div class='line' id='LC89'>&nbsp;&nbsp;</div><div class='line' id='LC90'>&nbsp;&nbsp;<span class="c1">// print it in a &#39;array&#39; format</span></div><div class='line' id='LC91'>&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">println</span><span class="o">(</span><span class="s">&quot;int IRsignal[] = {&quot;</span><span class="o">);</span></div><div class='line' id='LC92'>&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">println</span><span class="o">(</span><span class="s">&quot;// ON, OFF (in 10&#39;s of microseconds)&quot;</span><span class="o">);</span></div><div class='line' id='LC93'>&nbsp;&nbsp;<span class="k">for</span> <span class="o">(</span><span class="n">uint8_t</span> <span class="n">i</span> <span class="o">=</span> <span class="mi">0</span><span class="o">;</span> <span class="n">i</span> <span class="o">&lt;</span> <span class="n">currentpulse</span><span class="o">-</span><span class="mi">1</span><span class="o">;</span> <span class="n">i</span><span class="o">++)</span> <span class="o">{</span></div><div class='line' id='LC94'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="s">&quot;\t&quot;</span><span class="o">);</span> <span class="c1">// tab</span></div><div class='line' id='LC95'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="n">pulses</span><span class="o">[</span><span class="n">i</span><span class="o">][</span><span class="mi">1</span><span class="o">]</span> <span class="o">*</span> <span class="n">RESOLUTION</span> <span class="o">/</span> <span class="mi">10</span><span class="o">,</span> <span class="n">DEC</span><span class="o">);</span></div><div class='line' id='LC96'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="s">&quot;, &quot;</span><span class="o">);</span></div><div class='line' id='LC97'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="n">pulses</span><span class="o">[</span><span class="n">i</span><span class="o">+</span><span class="mi">1</span><span class="o">][</span><span class="mi">0</span><span class="o">]</span> <span class="o">*</span> <span class="n">RESOLUTION</span> <span class="o">/</span> <span class="mi">10</span><span class="o">,</span> <span class="n">DEC</span><span class="o">);</span></div><div class='line' id='LC98'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">println</span><span class="o">(</span><span class="s">&quot;,&quot;</span><span class="o">);</span></div><div class='line' id='LC99'>&nbsp;&nbsp;<span class="o">}</span></div><div class='line' id='LC100'>&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="s">&quot;\t&quot;</span><span class="o">);</span> <span class="c1">// tab</span></div><div class='line' id='LC101'>&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="n">pulses</span><span class="o">[</span><span class="n">currentpulse</span><span class="o">-</span><span class="mi">1</span><span class="o">][</span><span class="mi">1</span><span class="o">]</span> <span class="o">*</span> <span class="n">RESOLUTION</span> <span class="o">/</span> <span class="mi">10</span><span class="o">,</span> <span class="n">DEC</span><span class="o">);</span></div><div class='line' id='LC102'>&nbsp;&nbsp;<span class="n">Serial</span><span class="o">.</span><span class="na">print</span><span class="o">(</span><span class="s">&quot;, 0};&quot;</span><span class="o">);</span></div><div class='line' id='LC103'><span class="o">}</span></div><div class='line' id='LC104'><br/></div></pre></div>
          </td>
        </tr>
      </table>
  </div>

          </div>
        </div>
      </div>
    </div>

  </div>

<div class="frame frame-loading" style="display:none;" data-tree-list-url="/adafruit/Raw-IR-decoder-for-Arduino/tree-list/9914e3436547e1f0375a8f7453e7d1fa52660569" data-blob-url-prefix="/adafruit/Raw-IR-decoder-for-Arduino/blob/9914e3436547e1f0375a8f7453e7d1fa52660569">
  <img src="https://a248.e.akamai.net/assets.github.com/images/modules/ajax/big_spinner_336699.gif?1252203928" height="32" width="32">
</div>

      </div>
    </div>


      <!-- footer -->
      <div id="footer" >
        
  <div class="upper_footer">
     <div class="container clearfix">

       <!--[if IE]><h4 id="blacktocat_ie">GitHub Links</h4><![endif]-->
       <![if !IE]><h4 id="blacktocat">GitHub Links</h4><![endif]>

       <ul class="footer_nav">
         <h4>GitHub</h4>
         <li><a href="https://github.com/about">About</a></li>
         <li><a href="https://github.com/blog">Blog</a></li>
         <li><a href="https://github.com/features">Features</a></li>
         <li><a href="https://github.com/contact">Contact &amp; Support</a></li>
         <li><a href="https://github.com/training">Training</a></li>
         <li><a href="http://enterprise.github.com/">GitHub Enterprise</a></li>
         <li><a href="http://status.github.com/">Site Status</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Tools</h4>
         <li><a href="http://get.gaug.es/">Gauges: Analyze web traffic</a></li>
         <li><a href="http://speakerdeck.com">Speakerdeck: Presentations</a></li>
         <li><a href="https://gist.github.com">Gist: Code snippets</a></li>
         <li><a href="http://mac.github.com/">GitHub for Mac</a></li>
         <li><a href="http://mobile.github.com/">Issues for iPhone</a></li>
         <li><a href="http://jobs.github.com/">Job Board</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Extras</h4>
         <li><a href="http://shop.github.com/">GitHub Shop</a></li>
         <li><a href="http://octodex.github.com/">The Octodex</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Documentation</h4>
         <li><a href="http://help.github.com/">GitHub Help</a></li>
         <li><a href="http://developer.github.com/">Developer API</a></li>
         <li><a href="http://github.github.com/github-flavored-markdown/">GitHub Flavored Markdown</a></li>
         <li><a href="http://pages.github.com/">GitHub Pages</a></li>
       </ul>

     </div><!-- /.site -->
  </div><!-- /.upper_footer -->

<div class="lower_footer">
  <div class="container clearfix">
    <!--[if IE]><div id="legal_ie"><![endif]-->
    <![if !IE]><div id="legal"><![endif]>
      <ul>
          <li><a href="https://github.com/site/terms">Terms of Service</a></li>
          <li><a href="https://github.com/site/privacy">Privacy</a></li>
          <li><a href="https://github.com/security">Security</a></li>
      </ul>

      <p>&copy; 2012 <span id="_rrt" title="0.04276s from fe3.rs.github.com">GitHub</span> Inc. All rights reserved.</p>
    </div><!-- /#legal or /#legal_ie-->

      <div class="sponsor">
        <a href="http://www.rackspace.com" class="logo">
          <img alt="Dedicated Server" height="36" src="https://a248.e.akamai.net/assets.github.com/images/modules/footer/rackspace_logo.png?v2" width="38" />
        </a>
        Powered by the <a href="http://www.rackspace.com ">Dedicated
        Servers</a> and<br/> <a href="http://www.rackspacecloud.com">Cloud
        Computing</a> of Rackspace Hosting<span>&reg;</span>
      </div>
  </div><!-- /.site -->
</div><!-- /.lower_footer -->

      </div><!-- /#footer -->

    

<div id="keyboard_shortcuts_pane" class="instapaper_ignore readability-extra" style="display:none">
  <h2>Keyboard Shortcuts <small><a href="#" class="js-see-all-keyboard-shortcuts">(see all)</a></small></h2>

  <div class="columns threecols">
    <div class="column first">
      <h3>Site wide shortcuts</h3>
      <dl class="keyboard-mappings">
        <dt>s</dt>
        <dd>Focus site search</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>?</dt>
        <dd>Bring up this help dialog</dd>
      </dl>
    </div><!-- /.column.first -->

    <div class="column middle" style='display:none'>
      <h3>Commit list</h3>
      <dl class="keyboard-mappings">
        <dt>j</dt>
        <dd>Move selection down</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>k</dt>
        <dd>Move selection up</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>c <em>or</em> o <em>or</em> enter</dt>
        <dd>Open commit</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>y</dt>
        <dd>Expand URL to its canonical form</dd>
      </dl>
    </div><!-- /.column.first -->

    <div class="column last" style='display:none'>
      <h3>Pull request list</h3>
      <dl class="keyboard-mappings">
        <dt>j</dt>
        <dd>Move selection down</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>k</dt>
        <dd>Move selection up</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>o <em>or</em> enter</dt>
        <dd>Open issue</dd>
      </dl>
    </div><!-- /.columns.last -->

  </div><!-- /.columns.equacols -->

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Issues</h3>

    <div class="columns threecols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt>j</dt>
          <dd>Move selection down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>k</dt>
          <dd>Move selection up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>x</dt>
          <dd>Toggle selection</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>o <em>or</em> enter</dt>
          <dd>Open issue</dd>
        </dl>
      </div><!-- /.column.first -->
      <div class="column middle">
        <dl class="keyboard-mappings">
          <dt>I</dt>
          <dd>Mark selection as read</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>U</dt>
          <dd>Mark selection as unread</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>e</dt>
          <dd>Close selection</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>y</dt>
          <dd>Remove selection from view</dd>
        </dl>
      </div><!-- /.column.middle -->
      <div class="column last">
        <dl class="keyboard-mappings">
          <dt>c</dt>
          <dd>Create issue</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>l</dt>
          <dd>Create label</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>i</dt>
          <dd>Back to inbox</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>u</dt>
          <dd>Back to issues</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>/</dt>
          <dd>Focus issues search</dd>
        </dl>
      </div>
    </div>
  </div>

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Issues Dashboard</h3>

    <div class="columns threecols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt>j</dt>
          <dd>Move selection down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>k</dt>
          <dd>Move selection up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>o <em>or</em> enter</dt>
          <dd>Open issue</dd>
        </dl>
      </div><!-- /.column.first -->
    </div>
  </div>

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Network Graph</h3>
    <div class="columns equacols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt><span class="badmono">←</span> <em>or</em> h</dt>
          <dd>Scroll left</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">→</span> <em>or</em> l</dt>
          <dd>Scroll right</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">↑</span> <em>or</em> k</dt>
          <dd>Scroll up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">↓</span> <em>or</em> j</dt>
          <dd>Scroll down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>t</dt>
          <dd>Toggle visibility of head labels</dd>
        </dl>
      </div><!-- /.column.first -->
      <div class="column last">
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">←</span> <em>or</em> shift h</dt>
          <dd>Scroll all the way left</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">→</span> <em>or</em> shift l</dt>
          <dd>Scroll all the way right</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">↑</span> <em>or</em> shift k</dt>
          <dd>Scroll all the way up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">↓</span> <em>or</em> shift j</dt>
          <dd>Scroll all the way down</dd>
        </dl>
      </div><!-- /.column.last -->
    </div>
  </div>

  <div >
    <div class="rule"></div>
    <div class="columns threecols">
      <div class="column first" >
        <h3>Source Code Browsing</h3>
        <dl class="keyboard-mappings">
          <dt>t</dt>
          <dd>Activates the file finder</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>l</dt>
          <dd>Jump to line</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>w</dt>
          <dd>Switch branch/tag</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>y</dt>
          <dd>Expand URL to its canonical form</dd>
        </dl>
      </div>
    </div>
  </div>
</div>

    <div id="markdown-help" class="instapaper_ignore readability-extra">
  <h2>Markdown Cheat Sheet</h2>

  <div class="cheatsheet-content">

  <div class="mod">
    <div class="col">
      <h3>Format Text</h3>
      <p>Headers</p>
      <pre>
# This is an &lt;h1&gt; tag
## This is an &lt;h2&gt; tag
###### This is an &lt;h6&gt; tag</pre>
     <p>Text styles</p>
     <pre>
*This text will be italic*
_This will also be italic_
**This text will be bold**
__This will also be bold__

*You **can** combine them*
</pre>
    </div>
    <div class="col">
      <h3>Lists</h3>
      <p>Unordered</p>
      <pre>
* Item 1
* Item 2
  * Item 2a
  * Item 2b</pre>
     <p>Ordered</p>
     <pre>
1. Item 1
2. Item 2
3. Item 3
   * Item 3a
   * Item 3b</pre>
    </div>
    <div class="col">
      <h3>Miscellaneous</h3>
      <p>Images</p>
      <pre>
![GitHub Logo](/images/logo.png)
Format: ![Alt Text](url)
</pre>
     <p>Links</p>
     <pre>
http://github.com - automatic!
[GitHub](http://github.com)</pre>
<p>Blockquotes</p>
     <pre>
As Kanye West said:

> We're living the future so
> the present is our past.
</pre>
    </div>
  </div>
  <div class="rule"></div>

  <h3>Code Examples in Markdown</h3>
  <div class="col">
      <p>Syntax highlighting with <a href="http://github.github.com/github-flavored-markdown/" title="GitHub Flavored Markdown" target="_blank">GFM</a></p>
      <pre>
```javascript
function fancyAlert(arg) {
  if(arg) {
    $.facebox({div:'#foo'})
  }
}
```</pre>
    </div>
    <div class="col">
      <p>Or, indent your code 4 spaces</p>
      <pre>
Here is a Python code example
without syntax highlighting:

    def foo:
      if not bar:
        return true</pre>
    </div>
    <div class="col">
      <p>Inline code for comments</p>
      <pre>
I think you should use an
`&lt;addr&gt;` element here instead.</pre>
    </div>
  </div>

  </div>
</div>


    <div class="context-overlay"></div>

    <div class="ajax-error-message">
      <p><span class="icon"></span> Something went wrong with that request. Please try again. <a href="javascript:;" class="ajax-error-dismiss">Dismiss</a></p>
    </div>

    
    
    
  </body>
</html>

