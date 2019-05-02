Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A854F11B97
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 May 2019 16:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEBOhw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 May 2019 10:37:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBOhw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 May 2019 10:37:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1537260863; Thu,  2 May 2019 14:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556807872;
        bh=LFrnrg1kd52WYVEfpqt6x7qXfH3+6LG4aPrINU56sFQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PggLeIyrqgYZTXaGSJYZRamicPs/efCCoHcRQGtm223IYL7xcFnkgzNmaWb31vh22
         en6LdMJYHmhQsCBOZcjtDjBYaedMPbXHmqc43yeK9MoFvOUBKTM7g22jk6HCEUUfel
         giCm2bHOd+JBepEV9w1oclysnr1ZTSQnNKBYHpNs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from [10.204.79.15] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B901607C3;
        Thu,  2 May 2019 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556807871;
        bh=LFrnrg1kd52WYVEfpqt6x7qXfH3+6LG4aPrINU56sFQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AZixdJk/U74e2NG2xXw2qB0k18C4BojmhLUimCgLlQJ3NbXItjLv6raL1y9JuR7sd
         iwV/NWforWtg/Hywt/9BKAchq+elwr7kg62wC7VY0091OTr3wWzJ6CECs49ueTMCy4
         OX6rFDDo6g/SYVFsxxoCSCAo0/XFmctFfV6QzWAg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B901607C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH][next] KVM: PPC: Book3S HV: XIVE: fix spelling mistake
 "acessing" -> "accessing"
To:     Colin King <colin.king@canonical.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190502102313.25093-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <a7883281-bae0-694e-8436-f385023c1f88@codeaurora.org>
Date:   Thu, 2 May 2019 20:07:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502102313.25093-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 5/2/2019 3:53 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a pr_err message, fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh


> ---
>   arch/powerpc/kvm/book3s_xive_native.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index 5e14df1a4403..6a8e698c4b6e 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -235,7 +235,7 @@ static vm_fault_t xive_native_esb_fault(struct vm_fault *vmf)
>   	arch_spin_unlock(&sb->lock);
>   
>   	if (WARN_ON(!page)) {
> -		pr_err("%s: acessing invalid ESB page for source %lx !\n",
> +		pr_err("%s: accessing invalid ESB page for source %lx !\n",
>   		       __func__, irq);
>   		return VM_FAULT_SIGBUS;
>   	}
