import java.io.FileReader;
import java.io.FileWriter;
import android.widget.EditText;
import android.view.ViewGroup;
import android.view.Gravity;
import android.text.*;
import android.text.style.CharacterStyle;
import android.text.style.ForegroundColorSpan;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

EditText edit;
ColorScheme green = new ColorScheme(Pattern.compile("\\b(func|for|while|if|else|do)\\b"), color(0,255, 122));
ColorScheme red = new ColorScheme(Pattern.compile("\\b(return|break|continue|match|case|using|class)\\b"), color(255,126,128));
ColorScheme numbers = new ColorScheme(Pattern.compile("[0-9\\.]*"), color(144,61,255));
ColorScheme blue = new ColorScheme(Pattern.compile("\\b(print|println)\\b *\\("), color(108,131,255));


ColorScheme[] schemes = {numbers, green, red, blue};

class ColorScheme {
  final Pattern pattern;
  final int col;

  ColorScheme(Pattern pattern, int col) {
    this.pattern = pattern;
    this.col = col;
  }
}
int m =1;
float fx=0;
color col;
void setup() {
  col = color(#1D1D22); 
  edit = new EditText(getContext());
  
  edit.setY(10);
  edit.setHint("Enter code");
  edit.setTextSize(28);
  
  edit.setTextColor(color(255));
  edit.setGravity(Gravity.TOP);
  
  
  TextWatcher watcher = new TextWatcher() {
    
    public void afterTextChanged(Editable editable) {
      removeSpans(editable, ForegroundColorSpan.class);
      
      for(ColorScheme scheme : schemes) {
        for(Matcher m = scheme.pattern.matcher(editable); m.find();) {
          int start = m.start();
          int end = m.end();
          
          if(scheme.equals(blue)) 
            end = m.end()-1;
            
          editable.setSpan(new ForegroundColorSpan(scheme.col), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);   
        }
      }
    }
    
    void removeSpans(Editable e, Class<? extends CharacterStyle> type) {
      CharacterStyle[] spans = e.getSpans(0, e.length(), type);
      for(CharacterStyle span : spans) {
        e.removeSpan(span);
      }
    }
    
    public void beforeTextChanged(CharSequence p1, int p2, int p3, int p4) {}

    public void onTextChanged(CharSequence p1, int p2, int p3, int p4) {}
  };
        
  edit.addTextChangedListener(watcher);
  
  Runnable runnable = new Runnable() {
    void run() {
      ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
      getActivity().addContentView(edit, params);
    }
  };
  
  runOnUiThread(runnable);
}

void draw() {
  background(col);
  stroke(5);
}