Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630AB37D51
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jun 2019 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfFFTjJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jun 2019 15:39:09 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40774 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfFFTjJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jun 2019 15:39:09 -0400
Received: by mail-qk1-f193.google.com with SMTP id c70so2232586qkg.7
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jun 2019 12:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=FLwI6+5wMwdyc5kKGJFomLa/Z2aq5u3NjMcje63l998=;
        b=jz4maR4yAxExQ0eKYrH9gqXf2ST19g3Qsaw+KyC7z33RsrY6+leAlVEuGF6QeBfwh+
         QUbKjkWHTE7A04/MJnr5XIXjHNdC56U+QWof1qeTGYIgyAzVVLhZrs+I9pkwMmkrQSf9
         Q1lq/PkAgvqcK1AY8y2PxVbInTZO++unNIYo3+DQlaunQdTM9Z/Ce2fOm7S1/XrHJebI
         yoVugTXSt6vajQREDnmIw8GJp19iP01jKDHuCY/CH6e8XnFSfJwr+xP7C/El3YcGSVx5
         Rm5jazPBDx3aiAA8Hvm6Edj5E3JJvnlhOBbENlSISz1QUy6GQNKcUfaPf+dZio8NKlmi
         2dGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=FLwI6+5wMwdyc5kKGJFomLa/Z2aq5u3NjMcje63l998=;
        b=YiRhjK0kCdBDncpnpvZoWAehxeu9uMIs8YyMX+4XHd58pqxnabVoW3X6XA3q+/Xp3p
         AUeAA78kLS9JoaMucgm6iLSc4HfkOknLRtqidlWWBrHVaufZgbRJMiwBkGsyKCZdfXKt
         vkMqX7ChVi4NHOlPAvutpgTCW/TIyhoSNh/iswZFtE0uA4MOptDhrrOMw/DwsVUgw8xs
         dp+IbIV5NH7oytC1lIAlztVJfyTnqUj/xC2k7m1Xzek+MogOEL2YnQIYzdyRDmgI/hX9
         Gdw79/1Ly5O7I8Qum11/YSjeSiqbm+i6hArbG1SZuZfqoeJYjXUeLWobwcdWfLW7jdz8
         xh1A==
X-Gm-Message-State: APjAAAXGyMB6J7uFu71s5WXIOM+xgdCUmkP3ooukVsJ3wzOnpur3wDFH
        DgNnu1wnByaHsizcDbjUyIA=
X-Google-Smtp-Source: APXvYqzu3XMgIC1+ZJF2Bb5Vjsv12b98ODvNNxep7Jevb15/uPzAa/DGmkE3zbMvme+fXIvu1zf0FQ==
X-Received: by 2002:a05:620a:232:: with SMTP id u18mr21652131qkm.131.1559849948157;
        Thu, 06 Jun 2019 12:39:08 -0700 (PDT)
Received: from localhost (200-158-48-188.dsl.telesp.net.br. [200.158.48.188])
        by smtp.gmail.com with ESMTPSA id 17sm1544028qtr.65.2019.06.06.12.39.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 12:39:07 -0700 (PDT)
From:   Murilo Opsfelder =?utf-8?Q?Ara=C3=BAjo?= <mopsfelder@gmail.com>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 6/9] KVM: PPC: Ultravisor: Restrict flush of the partition tlb cache
In-Reply-To: <20190606173614.32090-7-cclaudio@linux.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com> <20190606173614.32090-7-cclaudio@linux.ibm.com>
Date:   Thu, 06 Jun 2019 16:39:04 -0300
Message-ID: <8736kmld0n.fsf@kermit.br.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:

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
> index 40a9fc8b139f..1eeb5fe87023 100644
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

checkpatch.pl seems to complain:

ERROR: need consistent spacing around '%' (ctx:WxV)
#125: FILE: arch/powerpc/mm/book3s64/pgtable.c:230:
+               asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 1) : :
                                             ^

ERROR: need consistent spacing around '%' (ctx:WxV)
#127: FILE: arch/powerpc/mm/book3s64/pgtable.c:232:
+               asm volatile(PPC_TLBIE_5(%0, %1, 2, 1, 1) : :
                                             ^

ERROR: need consistent spacing around '%' (ctx:WxV)
#131: FILE: arch/powerpc/mm/book3s64/pgtable.c:236:
+               asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 0) : :
                                             ^

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
> +		flush_partition(lpid, old);
>  }
>
>  void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
> --
> 2.20.1
