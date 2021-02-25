Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE206324EB5
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 12:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhBYLAh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 06:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhBYLAd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 06:00:33 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FD0C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 02:59:53 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p21so3523411pgl.12
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 02:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=xGroUyWCT31sVVQ60G/9L3y5R8a5+elyKISQ35AcBIU=;
        b=POgd72FP+RBHr/pG+sArA12DOyP6HehKQMpHUa+aDHxIjKW78C10mclu6bNMzWfYuo
         7+JW73xrmLqZmzityMUc+37wwQR3CuAwsJ1AfV0JBtYdUB/r9FZ9d2hF/exolZciIrV0
         ZxDaMA/cZU3ZB00kuF/4wsqMPTW6+h4OLdgTsRa2wmtCEfFRkVbiIow8iLhP+/VzhBAh
         JycKXsfAzm7SaHRbzwrKVL5zwSGtfQuRDinkFZxpRzEY+95ZCtB7NWx8IQaZjsGTi2Mz
         f5G9iWiKuCrxaSbaZMiRETqfRllUpMmrmA9NF4bHXmgkASPiTjplPiPBffSZn0/ulGR+
         t9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=xGroUyWCT31sVVQ60G/9L3y5R8a5+elyKISQ35AcBIU=;
        b=EAAI1hmYus0R+JMMIAwLUnE/U/8aCBbXemwdwUpR9FkH1jVtVlCwMH/aPbEh3gY0Dd
         jxqEdxOOYB5453fTMxN+8F7RXYDp+/ikoHe9eY6YJSbxUWbxcPfpf+NbaeolgvYIYZU4
         BQPptdEgMQ1t5ivGzqh5AI1OPMEaokvkSiioR/M1fbq5tyQ7gyK69Mf12BaaqsVFaNAw
         FiKmXqaDIp+wI8lR3JUjuGW+5suIAFZbC1e20LSbAk3Uu/x+AOwH11qOGsIXRUoHpdn7
         IVogSvo36BLXRN+oRCNR7kbjTWFx6RIyDTCWWCwmOqoYPy/hWL/SFlfS0D7r1TCv2Gsx
         nPkA==
X-Gm-Message-State: AOAM532OfBtGOcJrL4Wfra3eBdvOIl5K1rmhPyIqrrBrg6mEQgEXbjVN
        XzwC6QpAwFDEFJ9Ty+6H9bo=
X-Google-Smtp-Source: ABdhPJyDnUTqPNUoeLPpGS+f75QJ1DMvUVfllFD2r7Imr2pRu/wAyL9mbvtTSH7CgbzJSKXaNSILPQ==
X-Received: by 2002:a05:6a00:22ca:b029:1ed:f915:ca98 with SMTP id f10-20020a056a0022cab02901edf915ca98mr2692042pfj.68.1614250792901;
        Thu, 25 Feb 2021 02:59:52 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id 67sm6123116pfw.92.2021.02.25.02.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 02:59:52 -0800 (PST)
Date:   Thu, 25 Feb 2021 20:59:46 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 12/13] KVM: PPC: Book3S HV: Move radix MMU switching
 together in the P9 path
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210219063542.1425130-1-npiggin@gmail.com>
        <20210219063542.1425130-13-npiggin@gmail.com> <878s7dxkxr.fsf@linux.ibm.com>
In-Reply-To: <878s7dxkxr.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1614250755.4zzkisf6bg.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of February 25, 2021 6:36 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Switching the MMU from radix<->radix mode is tricky particularly as the
>> MMU can remain enabled and requires a certain sequence of SPR updates.
>> Move these together into their own functions.
>>
>> This also includes the radix TLB check / flush because it's tied in to
>> MMU switching due to tlbiel getting LPID from LPIDR.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>=20
> <snip>
>=20
>> @@ -4117,7 +4138,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u=
64 time_limit,
>>  {
>>  	struct kvm_run *run =3D vcpu->run;
>>  	int trap, r, pcpu;
>> -	int srcu_idx, lpid;
>> +	int srcu_idx;
>>  	struct kvmppc_vcore *vc;
>>  	struct kvm *kvm =3D vcpu->kvm;
>>  	struct kvm_nested_guest *nested =3D vcpu->arch.nested;
>> @@ -4191,13 +4212,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, =
u64 time_limit,
>>  	vc->vcore_state =3D VCORE_RUNNING;
>>  	trace_kvmppc_run_core(vc, 0);
>>
>> -	if (cpu_has_feature(CPU_FTR_HVMODE)) {
>> -		lpid =3D nested ? nested->shadow_lpid : kvm->arch.lpid;
>> -		mtspr(SPRN_LPID, lpid);
>> -		isync();
>> -		kvmppc_check_need_tlb_flush(kvm, pcpu, nested);
>> -	}
>> -
>=20
> What about the counterpart to this^ down below?
>=20
> 	if (cpu_has_feature(CPU_FTR_HVMODE)) {
> 		mtspr(SPRN_LPID, kvm->arch.host_lpid);
> 		isync();
> 	}

Good catch, you're right that can be removed too.

Thanks,
Nick
