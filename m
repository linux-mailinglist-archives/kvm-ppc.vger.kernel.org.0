Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD8B4B05F
	for <lists+kvm-ppc@lfdr.de>; Wed, 19 Jun 2019 05:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfFSDOL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Jun 2019 23:14:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34666 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbfFSDOL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 18 Jun 2019 23:14:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so8845046pfc.1
        for <kvm-ppc@vger.kernel.org>; Tue, 18 Jun 2019 20:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=VMq4w54Ji68zanfPCC9+A7bwX2siB4VWqOWAAOMdvkA=;
        b=IgdKSc2zqQpN1xOEaxk6nTp6Y2pnCIrqnOAIVo2CtJ3XFwC/l133m7zCaHDKTCmeH2
         k1dLHXOPT8HkfDl/wcEIZq+sqmCkcKOazik8vpi/eRWLqMrl/lGresrpy/NFn/e3dAbj
         9ZRLm/scwwsKCoUZMzuYkNjqgMuiCpuEztjz2lWSkR9U3+ZvI4a/rdej+gQyuFVxQBdj
         9jncw0+Ai5K90nFXKmOwhPBHAomRvaNcP/8pk/93uF2gNlu8W/OmJXU0vyKkfkMiIpMH
         crR4tB9szkoVsVy8gFGhCRzHzagd5wN8MykPDwxvoQbHGfEvFBqmkrwY3v0INny1mc/c
         VOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=VMq4w54Ji68zanfPCC9+A7bwX2siB4VWqOWAAOMdvkA=;
        b=n2fQ3i0uEeL1Io+WWUDys2Fg65rBZXL8pspBI78mOPo55v2JMoue7ciRoJV114yfwS
         hZ7yLRvDg8DfmVPt8C9ubgqjCL6D7I4RWdx6HYxJApIAW5npbE37W54l1SIrKImFedmo
         kPPt148e6vhRje7k7XPgYLFZ9Azbc6n3pQ1ZVEWJVmrXRnPALP4sy4wKjCL6URSleyao
         AA6H+sexQDR1ZSMMzuUa1Y2grjlNsfYYnpbOh09eH7lSYJUYVH3pMYJvTQHo+gfpbrYc
         BAkuCgfjoqJRMg4N7Zk8uXs8+4oHnYt78DQUt3J9crIUl244x2RYrtUXwuqt7KlMUhso
         MJGQ==
X-Gm-Message-State: APjAAAVpTWbwc4W+YvZlCJpGfOsD8tbuU2UbRKGyWLT57+HTQcR+aau3
        H1F07iHg9/o/S4PB/bn0WPUe7T0dsxM=
X-Google-Smtp-Source: APXvYqw/AJORJ8kHdNfUVKSS+h5bxsQsx6sERKNizclMqdo7Q4uS0cML+CrrMrLP7D7fqYSu9wG3/A==
X-Received: by 2002:a63:1322:: with SMTP id i34mr5764840pgl.424.1560914051131;
        Tue, 18 Jun 2019 20:14:11 -0700 (PDT)
Received: from localhost (193-116-92-108.tpgi.com.au. [193.116.92.108])
        by smtp.gmail.com with ESMTPSA id y1sm147010pje.1.2019.06.18.20.14.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 20:14:10 -0700 (PDT)
Date:   Wed, 19 Jun 2019 13:09:07 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 5/5] KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2)
 ADDR_TRANS_MODE mode
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org
References: <20190520005659.18628-1-npiggin@gmail.com>
        <20190520005659.18628-5-npiggin@gmail.com>
        <20190617055824.h6hkzbgp3h2cn3xg@oak.ozlabs.ibm.com>
In-Reply-To: <20190617055824.h6hkzbgp3h2cn3xg@oak.ozlabs.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1560912880.fo1v1pu7sd.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Paul Mackerras's on June 17, 2019 3:58 pm:
> On Mon, May 20, 2019 at 10:56:59AM +1000, Nicholas Piggin wrote:
>> AIL=3D2 mode has no known users, so is not well tested or supported.
>> Disallow guests from selecting this mode because it may become
>> deprecated in future versions of the architecture.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>=20
> Given that H_SET_MODE_RESOURCE_ADDR_TRANS_MODE gets punted to
> userspace (QEMU), why are we enforcing this here rather than in QEMU?

QEMU (appears to) support AIL=3D2. I don't propose to remove that
support (which could in theory be a regression for users). It
can't have ever worked properly for KVM guests though AFAIKS. Is
that reasonable?

> If there is a reason to do this here rather than in QEMU, then the
> patch description should really comment on why we're rejecting AIL=3D1
> as well as AIL=3D2.

Sure.

Thanks for review of the other patches as well, I think all your
points were valid so I'll fix them up before reposting.

Thanks,
Nick

>=20
>> ---
>>  arch/powerpc/kvm/book3s_hv.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 36d16740748a..4295ccdbee26 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -784,6 +784,11 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu,=
 unsigned long mflags,
>>  		vcpu->arch.dawr  =3D value1;
>>  		vcpu->arch.dawrx =3D value2;
>>  		return H_SUCCESS;
>> +	case H_SET_MODE_RESOURCE_ADDR_TRANS_MODE:
>> +		/* KVM does not support mflags=3D2 (AIL=3D2) */
>> +		if (mflags !=3D 0 && mflags !=3D 3)
>> +			return H_UNSUPPORTED_FLAG_START;
>> +		return H_TOO_HARD;
>>  	default:
>>  		return H_TOO_HARD;
>>  	}
>> --=20
>> 2.20.1
>=20
> Paul.
>=20
=
