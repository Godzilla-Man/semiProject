package kr.or.iei.comment.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class Comment {

   private String CommentNo;
   private String MemberNo;
   private String ProductNo;
   private String StylePostNo;
   private String Content;
   private String CreateDate;
}
