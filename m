Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0268C35D4CC
	for <lists+kvm-ppc@lfdr.de>; Tue, 13 Apr 2021 03:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbhDMB0Q (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Apr 2021 21:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbhDMB0Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Apr 2021 21:26:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61D4C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 18:25:57 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so9868357pjb.0
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 18:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=eTsr3d6eEOR1XzCTesXBOr0Fg+ji7sYoXLS4ON7fZRs=;
        b=Tv5h1wafbEIH7n1k/NLIvBt0+QeeH1lYum69s1tNNMTWJjDDNrcvVBMpMxsoEjApBe
         lbeSZQHtbnzqRchKUAd/SCjzVbZlVGotVtwusLfGdCA9XV57zsQhNWSBSeYXtdXuqZxv
         j3Vgov3oI1JFGsdU9c987DKs2ayTirLd/2B8RgRgvRKf8uvgLzsxkaNDbdm2k291MCvw
         N89jGeh76rD5AsYa0meWzErHPrW60pJOuYHl/vQ/Eohl50AP0q4T0vFTwbegGMQ4MtyA
         2eAJTrkPEaPhEpnfLcwJXWFJoDzxsT0+u7BGxrMs4+IZ0jSiBR7nu6oq4sQqtsr9jJEF
         z+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=eTsr3d6eEOR1XzCTesXBOr0Fg+ji7sYoXLS4ON7fZRs=;
        b=QZ5YtEb0DXlR+WW9ZUu0B3E/ydsoJpoIJKWbENXOED28wStwyOSEIbS6fwy6h4xTRP
         mpTk3jNe5qYbX6JesHIlYO/g9o60xsGLtzqgeOLgP7b5NY+7ycuPXszl4R874vGlUqV9
         +lPn1w6yJCGaX4ayGy4knGU+yLZ8wm0t1Fx3jwa8T9EtYVE/t4LNMO/Kr4eTPYyvedf4
         jrCHc7anH1Wqtn9TQnkQxsG2fvrfiHboGD74TsQR6CeDQBG24e5ttaIStorcVeCQdZxR
         hWVlXUHsaA77ChGPMltHMCOqwFa3e8gs0msfsWaF/18mjub2RoYCutxCFN7vDO4okGc7
         +qkg==
X-Gm-Message-State: AOAM533FHc+rAWKZ0PoYNdVq2BT4NZrCecEXxwRjqDKijc1kLUU66E25
        a+OlAVOzLc7m9jLNzN3Yw1hFIQ9XXzw=
X-Google-Smtp-Source: ABdhPJyhhV03O9hReo/24ro8yI4w/s0Iu7Uy2z6ZbFA4lwVcHK63Y8NhRy90xm45ymE6+owSdK5aeA==
X-Received: by 2002:a17:90b:608:: with SMTP id gb8mr2071317pjb.121.1618277157501;
        Mon, 12 Apr 2021 18:25:57 -0700 (PDT)
Received: from localhost (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id q17sm11893966pfq.171.2021.04.12.18.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 18:25:57 -0700 (PDT)
Date:   Tue, 13 Apr 2021 11:25:51 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v1 01/12] KVM: PPC: Book3S HV P9: Restore host CTRL SPR
 after guest exit
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210412014845.1517916-1-npiggin@gmail.com>
        <20210412014845.1517916-2-npiggin@gmail.com> <877dl761iv.fsf@linux.ibm.com>
In-Reply-To: <877dl761iv.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1618276972.38i1q7a28t.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of April 13, 2021 12:06 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> The host CTRL (runlatch) value is not restored after guest exit. The
>> host CTRL should always be 1 except in CPU idle code, so this can result
>> in the host running with runlatch clear, and potentially switching to
>> a different vCPU which then runs with runlatch clear as well.
>>
>> This has little effect on P9 machines, CTRL is only responsible for some
>> PMU counter logic in the host and so other than corner cases of software
>> relying on that, or explicitly reading the runlatch value (Linux does
>> not appear to be affected but it's possible non-Linux guests could be),
>> there should be no execution correctness problem, though it could be
>> used as a covert channel between guests.
>>
>> There may be microcontrollers, firmware or monitoring tools that sample
>> the runlatch value out-of-band, however since the register is writable
>> by guests, these values would (should) not be relied upon for correct
>> operation of the host, so suboptimal performance or incorrect reporting
>> should be the worst problem.
>>
>> Fixes: 95a6432ce9038 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit=
 path on P9 for radix guests")
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 13bad6bf4c95..208a053c9adf 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -3728,7 +3728,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *=
vcpu, u64 time_limit,
>>  	vcpu->arch.dec_expires =3D dec + tb;
>>  	vcpu->cpu =3D -1;
>>  	vcpu->arch.thread_cpu =3D -1;
>> +	/* Save guest CTRL register, set runlatch to 1 */
>>  	vcpu->arch.ctrl =3D mfspr(SPRN_CTRLF);
>> +	if (!(vcpu->arch.ctrl & 1))
>> +		mtspr(SPRN_CTRLT, vcpu->arch.ctrl | 1);
>=20
> Maybe ditch the comment and use the already defined CTRL_RUNLATCH?

I did it this way so you can more easily match up the C with the=20
existing asm version.

I have a later patch to clean up CTRL handling a bit (in both C and=20
asm).

Thanks,
Nick
