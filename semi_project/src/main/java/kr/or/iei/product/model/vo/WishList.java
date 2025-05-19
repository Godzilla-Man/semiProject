package kr.or.iei.product.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class WishList {

	private int wishListNo;
	private String productNo;
	private String memberNo;
	private String wishListDate;
}
