# 1.在线网站
https://regex-vis.com/ (https://github.com/Bowen7/regex-vis)
https://regexper.com/ (https://gitlab.com/javallone/regexper-static)
https://jex.im/regulex/ (https://github.com/CJex/regulex)
https://regex101.com/
https://www.regexplanet.com/advanced/java/index.html
https://regexr.com/
https://www.debuggex.com/

# 2.工具包
## 2.1 OWASP Enterprise Security API (ESAPI)
```
介绍：ESAPI 是一个为开发人员提供安全编码实践的开源工具包。
它包含了一些用于处理正则表达式的安全方法，可以帮助你避免常见的正则表达式安全漏洞。

import org.owasp.esapi.ESAPI;
import org.owasp.esapi.regex.MatchResult;
import org.owasp.esapi.regex.Pattern;

public class ESAPIRegexExample {
    public static void main(String[] args) {
        String regex = "\\d+";
        String input = "123";

        // 使用 ESAPI 编译正则表达式
        Pattern pattern = ESAPI.validator().getValidPattern(regex);
        MatchResult result = pattern.matcher(input).find();
        if (result.matched()) {
            System.out.println("匹配成功");
        } else {
            System.out.println("匹配失败");
        }
    }
}
```

## 2.2 ReDoS Detector
```
介绍：这是一个用于检测正则表达式是否存在灾难性回溯（ReDoS）漏洞的工具包。
它可以帮助你在代码中自动检测正则表达式的安全性。

import io.github.reactivecircus.redos.detector.ReDoSDetector;

public class ReDoSDetectorExample {
    public static void main(String[] args) {
        String regex = "(a+)+b";
        boolean hasVulnerability = ReDoSDetector.detect(regex);
        if (hasVulnerability) {
            System.out.println("正则表达式存在 ReDoS 漏洞");
        } else {
            System.out.println("正则表达式不存在 ReDoS 漏洞");
        }
    }
}
```