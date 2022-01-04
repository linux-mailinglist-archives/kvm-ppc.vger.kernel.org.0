Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AE8483EA6
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 Jan 2022 10:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiADJB4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 4 Jan 2022 04:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiADJBz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 4 Jan 2022 04:01:55 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECD6C061761
        for <kvm-ppc@vger.kernel.org>; Tue,  4 Jan 2022 01:01:54 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id g22so32189161pgn.1
        for <kvm-ppc@vger.kernel.org>; Tue, 04 Jan 2022 01:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Y2So0W6YNqWs/Z4tBX4iOrfUiW0ok+XM4vYBaYW+6r0=;
        b=ge9MpmvZKoxQve02hCmyWjv069pRt5BrkAgBhn5YzfzsRm7ZpM2biqjjYh/B3P9oJJ
         z30fmzDilPrdODJo5JLOBxhnzmdF48uLO4Gd3XASU6IhWbXMJiTqPk0m2kkgQIajOhtG
         3yJ41lJB+6CCQu58wr0GKmtpltuVhhUJewCQ2qm5Pxh84HtzRpBVUtU/mLPZkab1hnrq
         Q29v3nFWK+ddiS0Noq0dSNIeY8bzJuipO1/49ZlJj0I4UmZgLdEJOOLcek82kyykL/7g
         RrW9c1MlbDAbel3NwYq//h3MurElo9+dHRI+aQXar3+4wWYrXijXobtnL37cVCXlxDCd
         muNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y2So0W6YNqWs/Z4tBX4iOrfUiW0ok+XM4vYBaYW+6r0=;
        b=x9b8yWuuMdDJBHOZGk9YBv7mNOgqQCdL4pOv/0GQY2S9ccUqq+Y3ChLIrjgND+tnVG
         eYMzaKlOO0LyNj4PwyIQ6aT571ofTBo+fihDn8062y4Q+PgG0OUy5rvHtvmXRSM6T1FE
         hdOL1Hb/ek158lxE3HRfgQhV7wn+lB4S3tmk4vAgeEK4zQ86Ice4EPoSjEciVgpoqEdj
         LMSOvA8l63NSdOjUsZJsUtunO+NdYVpq0rAYSgaIWvaUm7VU6dfig/24+mIFYgfiCBSm
         29Xs4kesOWyGSdUXficNKkqWknZGxhqtWby33QyuP7R/ogPHOSIdt8ddy3isI9uQaWo5
         nvRQ==
X-Gm-Message-State: AOAM532DHXmSsl81STQiGsOrMddS2XDpHwSAaIP2SW3cNi5bwvIzAhZi
        2hmqFhpluZL3Qo5RaCs4Ki/MAw==
X-Google-Smtp-Source: ABdhPJze1p4UGEBkPj9+JKeFQTqSvEyiY3ZQvi+ep0cx7TO3xzwhO45/0viweKhn5n810FvANZXOzA==
X-Received: by 2002:a05:6a00:198a:b0:4bb:4621:f074 with SMTP id d10-20020a056a00198a00b004bb4621f074mr49693499pfl.69.1641286914547;
        Tue, 04 Jan 2022 01:01:54 -0800 (PST)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id oa9sm40441238pjb.31.2022.01.04.01.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 01:01:53 -0800 (PST)
Message-ID: <f9e1693a-d880-3c0a-f8e6-be4cda059650@ozlabs.ru>
Date:   Tue, 4 Jan 2022 20:01:49 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 2/3] KVM: PPC: Fix vmx/vsx mixup in mmio emulation
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20211223211528.3560711-1-farosas@linux.ibm.com>
 <20211223211528.3560711-3-farosas@linux.ibm.com>
 <1640427087.r4g49fcnps.astroid@bobo.none> <87zgomq7nn.fsf@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <87zgomq7nn.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 28/12/2021 04:28, Fabiano Rosas wrote:
> Nicholas Piggin <npiggin@gmail.com> writes:
> 
>> Excerpts from Fabiano Rosas's message of December 24, 2021 7:15 am:
>>> The MMIO emulation code for vector instructions is duplicated between
>>> VSX and VMX. When emulating VMX we should check the VMX copy size
>>> instead of the VSX one.
>>>
>>> Fixes: acc9eb9305fe ("KVM: PPC: Reimplement LOAD_VMX/STORE_VMX instruction ...")
>>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>>
>> Good catch. AFAIKS handle_vmx_store needs the same treatment? If you
>> agree then
> 
> Half the bug now, half the bug next year... haha I'll send a v2.
> 
> aside:
> All this duplication is kind of annoying. I'm looking into what it would
> take to have quadword instruction emulation here as well (Alexey caught
> a bug with syskaller) and the code would be really similar. I see that
> x86 has a more generic implementation that maybe we could take advantage
> of. See "f78146b0f923 (KVM: Fix page-crossing MMIO)"

Uff. My head exploded with vsx/vmx/vec :)
But this seems to have fixed "lvx" (which is vmx, right?).

Tested with: https://github.com/aik/linux/commits/my_kvm_tests



-- 
Alexey
