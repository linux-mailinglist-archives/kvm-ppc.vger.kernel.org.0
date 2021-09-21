Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0854129EC
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Sep 2021 02:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhIUAY6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Sep 2021 20:24:58 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.113]:36564 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230220AbhIUAW5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Sep 2021 20:22:57 -0400
X-Greylist: delayed 1208 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 20:22:57 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 29129181723
        for <kvm-ppc@vger.kernel.org>; Mon, 20 Sep 2021 19:01:20 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id STDsmPwK6MGeESTDsmXKPK; Mon, 20 Sep 2021 19:01:20 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=czSdDpNgb0Ii/RJWWpIWH8ssgyJ0ANHKIaZ5AJ+/NWg=; b=eTNSUnUcbS4YXJdyxijuf+L6bU
        +3nwvc5H7uG93RrOlY4XaQr+WJ8j5NasVF1FSOVL0/lk0bOYG9UZE8acN2rotuQu6llY12vdmrkGU
        V/wsZwwCXSGfqjcL47Efj5u5L7QG7rSltVQBuNf465bB8o++v9MW7Ru5j/oTS343jFEKZWZOwZPoZ
        Pm+Cg0lzTlOKUEcweILPt8iBUx3r/LhGmgqJfKT7Ch/3zTdxNnb6PVKumenkJm9EbYGGsCCT1Rt1V
        eT9MOfKYpHUcAA3fr58PiS5injGTx47qqOPbDuIfN/4ufmiTmASdY8S6YpDmURQ6RNucrEwqKf29z
        PtygWsHw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:33780 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mSTDr-000Y7U-Iv; Mon, 20 Sep 2021 19:01:19 -0500
Subject: Re: [PATCH] KVM: PPC: Replace zero-length array with flexible array
 member
To:     Len Baker <len.baker@gmx.com>, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210918142138.17709-1-len.baker@gmx.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <bb4faf3a-9fe9-280b-cb4c-e4904b0b2a8f@embeddedor.com>
Date:   Mon, 20 Sep 2021 19:05:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210918142138.17709-1-len.baker@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mSTDr-000Y7U-Iv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.9]) [187.162.31.110]:33780
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 9/18/21 09:21, Len Baker wrote:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use "flexible array members" [1] for these cases. The
> older style of one-element or zero-length arrays should no longer be
> used[2].
> 
> Also, make use of the struct_size() helper in kzalloc().
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  arch/powerpc/include/asm/kvm_host.h | 2 +-
>  arch/powerpc/kvm/book3s_64_vio.c    | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 080a7feb7731..3aed653373a5 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -190,7 +190,7 @@ struct kvmppc_spapr_tce_table {
>  	u64 size;		/* window size in pages */
>  	struct list_head iommu_tables;
>  	struct mutex alloc_lock;
> -	struct page *pages[0];
> +	struct page *pages[];
>  };
> 
>  /* XICS components, defined in book3s_xics.c */
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index 6365087f3160..d42b4b6d4a79 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -295,8 +295,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  		return ret;
> 
>  	ret = -ENOMEM;
> -	stt = kzalloc(sizeof(*stt) + npages * sizeof(struct page *),
> -		      GFP_KERNEL);
> +	stt = kzalloc(struct_size(stt, pages, npages), GFP_KERNEL);
>  	if (!stt)
>  		goto fail_acct;
> 
> --
> 2.25.1
> 
