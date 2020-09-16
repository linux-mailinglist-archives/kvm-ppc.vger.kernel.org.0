Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4222026BC8A
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Sep 2020 08:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIPGTN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Sep 2020 02:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPGTJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 16 Sep 2020 02:19:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93843C06174A;
        Tue, 15 Sep 2020 23:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=fse+h8UCPDsleRNPufm6YCU5bALHyxaJ9NrZcm6xYM8=; b=DsBud3yN3zMNa+2ZYy1fFVo6t6
        b+xLAGAzKH9Op3myuxDOH7JrQPH0g+Y0wi6n+ZmdCfJDEFuI1PA6lRnb5zu1m3v0oVnWPalTEXpoR
        +cPDQORK6hBHtAvSCyJo73Vf8XmZldkrg44MW4H7Af+x98KfFOBoTOFz2XSHDD89QHpBlDGhK0Shf
        xV1vaRVt0cm5Pqc+4qL6sfRC5tITrJnPNZiSoW/YJrMC7ejuq8bHD3nCRM2fFzul+EysUkUv6U5Gi
        VZJI3Krd3r6uX5jTnPaJId+Hal8YM6cSwm68plBGaCxTBCQrn3fD+UjPSsggdbQ3Lt1b8Jvwiwk4j
        o6Kp8nMw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIQmO-0006tb-Lm; Wed, 16 Sep 2020 06:18:57 +0000
Subject: Re: [PATCH] Doc: admin-guide: Add entry for kvm_cma_resv_ratio kernel
 param
To:     sathnaga@linux.vnet.ibm.com, linux-doc@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jonathan Corbet <corbet@lwn.net>
References: <20200916061130.723411-1-sathnaga@linux.vnet.ibm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <28eb9747-e4cc-424c-1f16-c68ed165b36a@infradead.org>
Date:   Tue, 15 Sep 2020 23:18:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916061130.723411-1-sathnaga@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 9/15/20 11:11 PM, sathnaga@linux.vnet.ibm.com wrote:
> From: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> 
> Add document entry for kvm_cma_resv_ratio kernel param which
> is used to alter the KVM contiguous memory allocation percentage
> for hash pagetable allocation used by hash mode PowerPC KVM guests.
> 
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm-ppc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Jonathan Corbet <corbet@lwn.net>  
> Signed-off-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a1068742a6df..9cb126573c71 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -599,6 +599,15 @@
>  			altogether. For more information, see
>  			include/linux/dma-contiguous.h
>  
> +        kvm_cma_resv_ratio=n
> +                        [PPC]

You can put [PPC] on the line above.

> +                        Reserves given percentage from system memory area for
> +                        contiguous memory allocation for KVM hash pagetable
> +                        allocation.
> +                        Bydefault it reserves 5% of total system memory.

			   By default

> +                        Format: <integer>
> +                        Default: 5
> +

and please use tabs for indentation, not all spaces.

>  	cmo_free_hint=	[PPC] Format: { yes | no }
>  			Specify whether pages are marked as being inactive
>  			when they are freed.  This is used in CMO environments
> 

Entries in kernel-parameters.txt should be sorted into dictionary order,
so please put that with the other kvm parameters.

thanks.
-- 
~Randy

