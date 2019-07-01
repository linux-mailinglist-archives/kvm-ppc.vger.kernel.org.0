Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BDD5B467
	for <lists+kvm-ppc@lfdr.de>; Mon,  1 Jul 2019 07:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfGAFyQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Jul 2019 01:54:16 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43753 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbfGAFyP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Jul 2019 01:54:15 -0400
Received: by mail-pl1-f193.google.com with SMTP id cl9so6708909plb.10
        for <kvm-ppc@vger.kernel.org>; Sun, 30 Jun 2019 22:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eceiVhMCm2jzMjMZWUfBDWQDfNbbCoL/myYhskQ11u8=;
        b=FTYR690RsdJyOvbuJatVKkrCgcrQ51eXwtQTV+L5LQ6OhMwgxPqResopzpjDk5Xn5S
         Ik9F+qGexTmezEzXZSUl/kVxwzDhkA51THD4EsMrCXXRj7n/9JWpyukfMFH8MW1LovkZ
         5j3ZocrGXI8FqfSAAqvuCwPW6IylBXhDybmZagUvAfyrlIt8ee2nGW9elLmkUpF6jriu
         Q234NObKni5vNrcPYKLvf61E3iELH4DNKsmckAe2L7p/kCjhpqui7ShazPJVMYrfyQni
         yqtJwnIrfuwQyEQy1WqcXQsE4zN0fikoIHil+AbG6Zt63UobO53iRDRsI0WeeYdAioye
         hBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eceiVhMCm2jzMjMZWUfBDWQDfNbbCoL/myYhskQ11u8=;
        b=c33XadT7opqjBkKEecl6iMCGlySeRoHqCfLUUmrXfXvVe2gRxxM1lMcxy91V+PcccJ
         jCRPHS0XFVjvCBb5LBIWmRMw08UCKuTo6a2a2+YutAk0A0iOk31HXmQGWslFAi8UnnAp
         fzSZPFJWnWblXBoybLeGCDN+nhpY6Ck1q5D3rtssTkj27hfINMRa1fFpys3/rnyBAKN9
         Q2kCEgvmpj1ey13I9ICCb4eOgUt5yaUOHv3jFoyhTle26GO7A9JmFAdla3kQ9Yr2/p0Y
         eJy7V3R5kdTKnUuNegfLsqry8CWj7MvLV2Af3RtpEeDqcF+RM/DzgdgoQKNGIJ+uGr2v
         o6aQ==
X-Gm-Message-State: APjAAAWgja6qNExWP1kReK7UdvJOtNvh4iFMC6SwNLTFI+325MskqYiE
        LKmPa+xPGTeiRA5EIt0YWiZ5ng==
X-Google-Smtp-Source: APXvYqzWn0Z6rO+JtgNuBidGaMXV6UHD4dCNXf6dZyMISiziV2P25THDIeIu8IkdMKoPVWJXQJ8ptg==
X-Received: by 2002:a17:902:9a49:: with SMTP id x9mr15583196plv.282.1561960455096;
        Sun, 30 Jun 2019 22:54:15 -0700 (PDT)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id i9sm6403893pgo.46.2019.06.30.22.54.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 22:54:14 -0700 (PDT)
Subject: Re: [PATCH v4 5/8] KVM: PPC: Ultravisor: Restrict flush of the
 partition tlb cache
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-6-cclaudio@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Openpgp: preference=signencrypt
Autocrypt: addr=aik@ozlabs.ru; keydata=
 mQINBE+rT0sBEADFEI2UtPRsLLvnRf+tI9nA8T91+jDK3NLkqV+2DKHkTGPP5qzDZpRSH6mD
 EePO1JqpVuIow/wGud9xaPA5uvuVgRS1q7RU8otD+7VLDFzPRiRE4Jfr2CW89Ox6BF+q5ZPV
 /pS4v4G9eOrw1v09lEKHB9WtiBVhhxKK1LnUjPEH3ifkOkgW7jFfoYgTdtB3XaXVgYnNPDFo
 PTBYsJy+wr89XfyHr2Ev7BB3Xaf7qICXdBF8MEVY8t/UFsesg4wFWOuzCfqxFmKEaPDZlTuR
 tfLAeVpslNfWCi5ybPlowLx6KJqOsI9R2a9o4qRXWGP7IwiMRAC3iiPyk9cknt8ee6EUIxI6
 t847eFaVKI/6WcxhszI0R6Cj+N4y+1rHfkGWYWupCiHwj9DjILW9iEAncVgQmkNPpUsZECLT
 WQzMuVSxjuXW4nJ6f4OFHqL2dU//qR+BM/eJ0TT3OnfLcPqfucGxubhT7n/CXUxEy+mvWwnm
 s9p4uqVpTfEuzQ0/bE6t7dZdPBua7eYox1AQnk8JQDwC3Rn9kZq2O7u5KuJP5MfludMmQevm
 pHYEMF4vZuIpWcOrrSctJfIIEyhDoDmR34bCXAZfNJ4p4H6TPqPh671uMQV82CfTxTrMhGFq
 8WYU2AH86FrVQfWoH09z1WqhlOm/KZhAV5FndwVjQJs1MRXD8QARAQABtCRBbGV4ZXkgS2Fy
 ZGFzaGV2c2tpeSA8YWlrQG96bGFicy5ydT6JAjgEEwECACIFAk+rT0sCGwMGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheAAAoJEIYTPdgrwSC5fAIP/0wf/oSYaCq9PhO0UP9zLSEz66SSZUf7
 AM9O1rau1lJpT8RoNa0hXFXIVbqPPKPZgorQV8SVmYRLr0oSmPnTiZC82x2dJGOR8x4E01gK
 TanY53J/Z6+CpYykqcIpOlGsytUTBA+AFOpdaFxnJ9a8p2wA586fhCZHVpV7W6EtUPH1SFTQ
 q5xvBmr3KkWGjz1FSLH4FeB70zP6uyuf/B2KPmdlPkyuoafl2UrU8LBADi/efc53PZUAREih
 sm3ch4AxaL4QIWOmlE93S+9nHZSRo9jgGXB1LzAiMRII3/2Leg7O4hBHZ9Nki8/fbDo5///+
 kD4L7UNbSUM/ACWHhd4m1zkzTbyRzvL8NAVQ3rckLOmju7Eu9whiPueGMi5sihy9VQKHmEOx
 OMEhxLRQbzj4ypRLS9a+oxk1BMMu9cd/TccNy0uwx2UUjDQw/cXw2rRWTRCxoKmUsQ+eNWEd
 iYLW6TCfl9CfHlT6A7Zmeqx2DCeFafqEd69DqR9A8W5rx6LQcl0iOlkNqJxxbbW3ddDsLU/Y
 r4cY20++WwOhSNghhtrroP+gouTOIrNE/tvG16jHs8nrYBZuc02nfX1/gd8eguNfVX/ZTHiR
 gHBWe40xBKwBEK2UeqSpeVTohYWGBkcd64naGtK9qHdo1zY1P55lHEc5Uhlk743PgAnOi27Q
 ns5zuQINBE+rT0sBEACnV6GBSm+25ACT+XAE0t6HHAwDy+UKfPNaQBNTTt31GIk5aXb2Kl/p
 AgwZhQFEjZwDbl9D/f2GtmUHWKcCmWsYd5M/6Ljnbp0Ti5/xi6FyfqnO+G/wD2VhGcKBId1X
 Em/B5y1kZVbzcGVjgD3HiRTqE63UPld45bgK2XVbi2+x8lFvzuFq56E3ZsJZ+WrXpArQXib2
 hzNFwQleq/KLBDOqTT7H+NpjPFR09Qzfa7wIU6pMNF2uFg5ihb+KatxgRDHg70+BzQfa6PPA
 o1xioKXW1eHeRGMmULM0Eweuvpc7/STD3K7EJ5bBq8svoXKuRxoWRkAp9Ll65KTUXgfS+c0x
 gkzJAn8aTG0z/oEJCKPJ08CtYQ5j7AgWJBIqG+PpYrEkhjzSn+DZ5Yl8r+JnZ2cJlYsUHAB9
 jwBnWmLCR3gfop65q84zLXRQKWkASRhBp4JK3IS2Zz7Nd/Sqsowwh8x+3/IUxVEIMaVoUaxk
 Wt8kx40h3VrnLTFRQwQChm/TBtXqVFIuv7/Mhvvcq11xnzKjm2FCnTvCh6T2wJw3de6kYjCO
 7wsaQ2y3i1Gkad45S0hzag/AuhQJbieowKecuI7WSeV8AOFVHmgfhKti8t4Ff758Z0tw5Fpc
 BFDngh6Lty9yR/fKrbkkp6ux1gJ2QncwK1v5kFks82Cgj+DSXK6GUQARAQABiQIfBBgBAgAJ
 BQJPq09LAhsMAAoJEIYTPdgrwSC5NYEP/2DmcEa7K9A+BT2+G5GXaaiFa098DeDrnjmRvumJ
 BhA1UdZRdfqICBADmKHlJjj2xYo387sZpS6ABbhrFxM6s37g/pGPvFUFn49C47SqkoGcbeDz
 Ha7JHyYUC+Tz1dpB8EQDh5xHMXj7t59mRDgsZ2uVBKtXj2ZkbizSHlyoeCfs1gZKQgQE8Ffc
 F8eWKoqAQtn3j4nE3RXbxzTJJfExjFB53vy2wV48fUBdyoXKwE85fiPglQ8bU++0XdOr9oyy
 j1llZlB9t3tKVv401JAdX8EN0++ETiOovQdzE1m+6ioDCtKEx84ObZJM0yGSEGEanrWjiwsa
 nzeK0pJQM9EwoEYi8TBGhHC9ksaAAQipSH7F2OHSYIlYtd91QoiemgclZcSgrxKSJhyFhmLr
 QEiEILTKn/pqJfhHU/7R7UtlDAmFMUp7ByywB4JLcyD10lTmrEJ0iyRRTVfDrfVP82aMBXgF
 tKQaCxcmLCaEtrSrYGzd1sSPwJne9ssfq0SE/LM1J7VdCjm6OWV33SwKrfd6rOtvOzgadrG6
 3bgUVBw+bsXhWDd8tvuCXmdY4bnUblxF2B6GOwSY43v6suugBttIyW5Bl2tXSTwP+zQisOJo
 +dpVG2pRr39h+buHB3NY83NEPXm1kUOhduJUA17XUY6QQCAaN4sdwPqHq938S3EmtVhsuQIN
 BFq54uIBEACtPWrRdrvqfwQF+KMieDAMGdWKGSYSfoEGGJ+iNR8v255IyCMkty+yaHafvzpl
 PFtBQ/D7Fjv+PoHdFq1BnNTk8u2ngfbre9wd9MvTDsyP/TmpF0wyyTXhhtYvE267Av4X/BQT
 lT9IXKyAf1fP4BGYdTNgQZmAjrRsVUW0j6gFDrN0rq2J9emkGIPvt9rQt6xGzrd6aXonbg5V
 j6Uac1F42ESOZkIh5cN6cgnGdqAQb8CgLK92Yc8eiCVCH3cGowtzQ2m6U32qf30cBWmzfSH0
 HeYmTP9+5L8qSTA9s3z0228vlaY0cFGcXjdodBeVbhqQYseMF9FXiEyRs28uHAJEyvVZwI49
 CnAgVV/n1eZa5qOBpBL+ZSURm8Ii0vgfvGSijPGbvc32UAeAmBWISm7QOmc6sWa1tobCiVmY
 SNzj5MCNk8z4cddoKIc7Wt197+X/X5JPUF5nQRvg3SEHvfjkS4uEst9GwQBpsbQYH9MYWq2P
 PdxZ+xQE6v7cNB/pGGyXqKjYCm6v70JOzJFmheuUq0Ljnfhfs15DmZaLCGSMC0Amr+rtefpA
 y9FO5KaARgdhVjP2svc1F9KmTUGinSfuFm3quadGcQbJw+lJNYIfM7PMS9fftq6vCUBoGu3L
 j4xlgA/uQl/LPneu9mcvit8JqcWGS3fO+YeagUOon1TRqQARAQABiQRsBBgBCAAgFiEEZSrP
 ibrORRTHQ99dhhM92CvBILkFAlq54uICGwICQAkQhhM92CvBILnBdCAEGQEIAB0WIQQIhvWx
 rCU+BGX+nH3N7sq0YorTbQUCWrni4gAKCRDN7sq0YorTbVVSD/9V1xkVFyUCZfWlRuryBRZm
 S4GVaNtiV2nfUfcThQBfF0sSW/aFkLP6y+35wlOGJE65Riw1C2Ca9WQYk0xKvcZrmuYkK3DZ
 0M9/Ikkj5/2v0vxz5Z5w/9+IaCrnk7pTnHZuZqOh23NeVZGBls/IDIvvLEjpD5UYicH0wxv+
 X6cl1RoP2Kiyvenf0cS73O22qSEw0Qb9SId8wh0+ClWet2E7hkjWFkQfgJ3hujR/JtwDT/8h
 3oCZFR0KuMPHRDsCepaqb/k7VSGTLBjVDOmr6/C9FHSjq0WrVB9LGOkdnr/xcISDZcMIpbRm
 EkIQ91LkT/HYIImL33ynPB0SmA+1TyMgOMZ4bakFCEn1vxB8Ir8qx5O0lHMOiWMJAp/PAZB2
 r4XSSHNlXUaWUg1w3SG2CQKMFX7vzA31ZeEiWO8tj/c2ZjQmYjTLlfDK04WpOy1vTeP45LG2
 wwtMA1pKvQ9UdbYbovz92oyZXHq81+k5Fj/YA1y2PI4MdHO4QobzgREoPGDkn6QlbJUBf4To
 pEbIGgW5LRPLuFlOPWHmIS/sdXDrllPc29aX2P7zdD/ivHABslHmt7vN3QY+hG0xgsCO1JG5
 pLORF2N5XpM95zxkZqvYfC5tS/qhKyMcn1kC0fcRySVVeR3tUkU8/caCqxOqeMe2B6yTiU1P
 aNDq25qYFLeYxg67D/4w/P6BvNxNxk8hx6oQ10TOlnmeWp1q0cuutccblU3ryRFLDJSngTEu
 ZgnOt5dUFuOZxmMkqXGPHP1iOb+YDznHmC0FYZFG2KAc9pO0WuO7uT70lL6larTQrEneTDxQ
 CMQLP3qAJ/2aBH6SzHIQ7sfbsxy/63jAiHiT3cOaxAKsWkoV2HQpnmPOJ9u02TPjYmdpeIfa
 X2tXyeBixa3i/6dWJ4nIp3vGQicQkut1YBwR7dJq67/FCV3Mlj94jI0myHT5PIrCS2S8LtWX
 ikTJSxWUKmh7OP5mrqhwNe0ezgGiWxxvyNwThOHc5JvpzJLd32VDFilbxgu4Hhnf6LcgZJ2c
 Zd44XWqUu7FzVOYaSgIvTP0hNrBYm/E6M7yrLbs3JY74fGzPWGRbBUHTZXQEqQnZglXaVB5V
 ZhSFtHopZnBSCUSNDbB+QGy4B/E++Bb02IBTGl/JxmOwG+kZUnymsPvTtnNIeTLHxN/H/ae0
 c7E5M+/NpslPCmYnDjs5qg0/3ihh6XuOGggZQOqrYPC3PnsNs3NxirwOkVPQgO6mXxpuifvJ
 DG9EMkK8IBXnLulqVk54kf7fE0jT/d8RTtJIA92GzsgdK2rpT1MBKKVffjRFGwN7nQVOzi4T
 XrB5p+6ML7Bd84xOEGsj/vdaXmz1esuH7BOZAGEZfLRCHJ0GVCSssg==
Message-ID: <bd65a80e-c935-d612-bbbd-9ef7cc68d7e3@ozlabs.ru>
Date:   Mon, 1 Jul 2019 15:54:08 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628200825.31049-6-cclaudio@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 29/06/2019 06:08, Claudio Carvalho wrote:
> From: Ram Pai <linuxram@us.ibm.com>
> 
> Ultravisor is responsible for flushing the tlb cache, since it manages
> the PATE entries. Hence skip tlb flush, if the ultravisor firmware is
> available.
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
>  arch/powerpc/mm/book3s64/pgtable.c | 33 +++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
> index 224c5c7c2e3d..bc8eb2bf9810 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -224,6 +224,23 @@ void __init mmu_partition_table_init(void)
>  	powernv_set_nmmu_ptcr(ptcr);
>  }
>  
> +static void flush_partition(unsigned int lpid, unsigned long dw0)
> +{
> +	if (dw0 & PATB_HR) {
> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 1) : :
> +			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 1, 1) : :
> +			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> +		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
> +	} else {
> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 0) : :
> +			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> +		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
> +	}
> +	/* do we need fixup here ?*/
> +	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
> +}
> +
>  static void __mmu_partition_table_set_entry(unsigned int lpid,
>  					    unsigned long dw0,
>  					    unsigned long dw1)
> @@ -238,20 +255,8 @@ static void __mmu_partition_table_set_entry(unsigned int lpid,
>  	 * The type of flush (hash or radix) depends on what the previous
>  	 * use of this partition ID was, not the new use.
>  	 */
> -	asm volatile("ptesync" : : : "memory");
> -	if (old & PATB_HR) {
> -		asm volatile(PPC_TLBIE_5(%0,%1,2,0,1) : :
> -			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> -		asm volatile(PPC_TLBIE_5(%0,%1,2,1,1) : :
> -			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> -		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
> -	} else {
> -		asm volatile(PPC_TLBIE_5(%0,%1,2,0,0) : :
> -			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> -		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
> -	}
> -	/* do we need fixup here ?*/
> -	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
> +	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))


__mmu_partition_table_set_entry() checks for UV and
mmu_partition_table_set_entry() (the caller) checks for UV and the whole
point of having separate flush_partition() and
__mmu_partition_table_set_entry() is not really clear.


4/8 and 5/8 make more sense as one patch imho.


> +		flush_partition(lpid, old);
>  }
>  
>  void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
> 

-- 
Alexey
