package controller;

import component.member.*;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.apache.ibatis.exceptions.TooManyResultsException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import security.token.TokenGeneratorService;

import javax.servlet.http.HttpServletRequest;
import java.sql.Date;
import java.sql.SQLIntegrityConstraintViolationException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

/**
 * handle member's service (register, login, find password and so on)
 */
@RestController
@RequestMapping(value = "/member")
@Log4j
public class MemberController {

    /**
     * member service(register, login, find password and so on)
     */
    @Setter(onMethod_ = @Autowired)
    private MemberService memberService;

    /**
     * password encoder
     */
    @Setter(onMethod_ = {@Autowired})
    private BCryptPasswordEncoder passwordEncoder;

    /**
     * for generating token (to use application service)
     */
    @Setter(onMethod_ = {@Autowired})
    private TokenGeneratorService tokenGeneratorService;

    @ExceptionHandler(NullPointerException.class)
    public HashMap<String, String> handlerNullPointerException(Exception e) {
        e.printStackTrace();
        HashMap<String, String> hashMap = new HashMap<>();
        hashMap.put("error", e.getMessage());
        hashMap.put("code", "500");
        return hashMap;
    }

    /**
     * @param request member login(normal or tmp password)
     * @return
     */
    @RequestMapping(value = "/login.do")
    public String memberLogin(HttpServletRequest request) {
        String email = request.getParameter("email");
        String pw = request.getParameter("pw");
        MemberTmpInfoDTO tmpInfoDTO = memberService.selectsByTmpInfo(email);
        if (tmpInfoDTO != null && passwordEncoder.matches(pw, tmpInfoDTO.getPw())) {
            System.out.println(tmpInfoDTO.getEmail() + "," + tmpInfoDTO.getPw());
            return tokenGeneratorService.createToken(email, 1000 * 60 * 60 * 24);
        }
        MemberVO memberVO = memberService.selects(email);
        if (memberVO != null && pw != null && passwordEncoder.matches(pw, memberVO.getPw())) {
            return tokenGeneratorService.createToken(email, 1000 * 60 * 60 * 24);
        }
        return "fail";
    }

    @PostMapping(value = "/register.do")
    public int insertMember(@RequestBody MemberDTO memberDTO) {
        System.out.println(memberDTO);
        String pw = memberDTO.getPw();
        String sex = memberDTO.getSex();
        String bornTime = memberDTO.getBornTime();
        if (sex.equals("")) {
            memberDTO.setSex("N");
        }
        if (bornTime.equals("")) {
            memberDTO.setBornTime("N");
        }

        // todo 1. pw check(right format?)
        String encodedPassword = passwordEncoder.encode(pw); // salt 와 평문 문자열을 2번 인코딩
        memberDTO.setPw(encodedPassword);

        int affectedRowOfRegisterMember = memberService.registerMember(memberDTO);
        if (affectedRowOfRegisterMember == 1) {
            return 100;
        }
        return 101;
    }



    @PostMapping(value = "/timer/get.do")
    public List<MemberTimerVO> getTimers(@RequestParam("token") String token) {
        String email = tokenGeneratorService.getSubject(token);
        return memberService.selectTimer(email);
    }

    @PostMapping(value = "/timer/insert.do")
    public int insertTimer(HttpServletRequest request) {
        String token = request.getParameter("email");
        String email = tokenGeneratorService.getSubject(token);
        String seconds = request.getParameter("sec");
        int sec = Integer.parseInt(seconds);

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("email", email);
        hashMap.put("sec", sec);

        return memberService.insertTimer(hashMap);
    }



}
