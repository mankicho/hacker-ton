package component.member;

import lombok.Data;

import java.sql.Date;
import java.sql.Time;

@Data
public class MemberTimerVO {
    private String email;
    private Date focusDate;
    private int focusTime;
}
