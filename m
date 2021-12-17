Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D9847837A
	for <lists+kvm-ppc@lfdr.de>; Fri, 17 Dec 2021 04:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhLQDHM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 16 Dec 2021 22:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhLQDHL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 16 Dec 2021 22:07:11 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FEDC06173E
        for <kvm-ppc@vger.kernel.org>; Thu, 16 Dec 2021 19:07:11 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d11so848023pgl.1
        for <kvm-ppc@vger.kernel.org>; Thu, 16 Dec 2021 19:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hqVeHYszJrco9ra2C2j8EHyWbAh1gF1XNTB+IDSGnkA=;
        b=iN8HmKrVxt9lDjYWhkv3zQxN0RsFwJipjLVg/CpyYVKDbnOpE7+sppxleWAOKvAUYt
         /vs+W5tTUWcVFpVkza3BPSSBSsE2OSzA+dWxVtU2rP+p6G70Yc6mBjpye3oEulabdFw9
         n75XUtpOn78rDY0AuTOMmgikPJjHZVEeae4Meo5oorSqISHjDLjLQieddAgwWW6rGdc/
         R48/uss4DnWlZRiGwOcBr5bQMy6wgMP60Hqclcf8tO0ikcpfiyF1C3Fajdt8V5pGzbRL
         wIFmaxOjOvXqciceCy6OZpnTfiAjesS04p/5EZc1fT9OwCHXQUOjgh602ZPIIrbuv4NW
         Vugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hqVeHYszJrco9ra2C2j8EHyWbAh1gF1XNTB+IDSGnkA=;
        b=cgPWZekZGoGriRKa/GaRBqrr9Q4zNg8l7yE9IwRP20OT+MQuqo7uY2R0OYXcg61bR+
         cOsxzSU1o272KKSRKI11qjppbLpmIId5stNguNX/07Vjqe3zO7sR1TRUog6MdZi/KIf4
         BgM57zfNxoAs4YaenuEDajg+d42n9AMZ1Yag+A9y/GJjQmZtsF3Jyog3urY3xThOfydR
         foPkE7zsYANy7JuWEW4ZSIX+v9EUS6pKmdyChTuc4wVhawpXNGgyZ7QGXU7lEZ8cuCAx
         LdmL1XT+HHtO4eyZJkEBGoqvtLUtEISge4xH3AKk3JEAlzFrpSJVsEID7kuGXQJq8vgc
         XBvw==
X-Gm-Message-State: AOAM532jTVWTFbOaqg6lGqK7yBp4h7lAkrGqOvlq50Zi9+mV60QqcWHy
        iSFJLlbEKkGPHh7V9jJ38POH6g==
X-Google-Smtp-Source: ABdhPJzicJEgh8Afueuqf6fIiQw6DhvqKmheZLxm2ppty6gVVTSeoRHzK5ZA6uGKH0l8i7HYsn4atw==
X-Received: by 2002:a63:d753:: with SMTP id w19mr1095375pgi.174.1639710430889;
        Thu, 16 Dec 2021 19:07:10 -0800 (PST)
Received: from [192.168.10.24] (124-171-108-209.dyn.iinet.net.au. [124.171.108.209])
        by smtp.gmail.com with ESMTPSA id s38sm7998233pfg.17.2021.12.16.19.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 19:07:09 -0800 (PST)
Message-ID: <e59eaa8c-6c60-521f-dc5d-d7c549a7c80f@ozlabs.ru>
Date:   Fri, 17 Dec 2021 14:07:05 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH kernel v3] KVM: PPC: Merge powerpc's debugfs entry content
 into generic entry
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Fabiano Rosas <farosas@linux.ibm.com>
References: <20211215013309.217102-1-aik@ozlabs.ru>
 <d980eeb7-1f32-dbd3-f60d-ea6ef24dbaaa@kaod.org>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <d980eeb7-1f32-dbd3-f60d-ea6ef24dbaaa@kaod.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 12/16/21 05:11, Cédric Le Goater wrote:
> On 12/15/21 02:33, Alexey Kardashevskiy wrote:
>> At the moment KVM on PPC creates 3 types of entries under the kvm debugfs:
>> 1) "%pid-%fd" per a KVM instance (for all platforms);
>> 2) "vm%pid" (for PPC Book3s HV KVM);
>> 3) "vm%u_vcpu%u_timing" (for PPC Book3e KVM).
>>
>> The problem with this is that multiple VMs per process is not allowed for
>> 2) and 3) which makes it possible for userspace to trigger errors when
>> creating duplicated debugfs entries.
>>
>> This merges all these into 1).
>>
>> This defines kvm_arch_create_kvm_debugfs() similar to
>> kvm_arch_create_vcpu_debugfs().
>>
>> This defines 2 hooks in kvmppc_ops that allow specific KVM implementations
>> add necessary entries, this adds the _e500 suffix to
>> kvmppc_create_vcpu_debugfs_e500() to make it clear what platform it is for.
>>
>> This makes use of already existing kvm_arch_create_vcpu_debugfs() on PPC.
>>
>> This removes no more used debugfs_dir pointers from PPC kvm_arch structs.
>>
>> This stops removing vcpu entries as once created vcpus stay around
>> for the entire life of a VM and removed when the KVM instance is closed,
>> see commit d56f5136b010 ("KVM: let kvm_destroy_vm_debugfs clean up vCPU
>> debugfs directories").
> 
> It would nice to also move the KVM device debugfs files :
> 
>    /sys/kernel/debug/powerpc/kvm-xive-%p
> 
> These are dynamically created and destroyed at run time depending
> on the interrupt mode negociated by CAS. It might be more complex ?

With this addition:

diff --git a/arch/powerpc/kvm/book3s_xive_native.c
b/arch/powerpc/kvm/book3s_xive_native.c
index 99db9ac49901..511f643e2875 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1267,10 +1267,10 @@ static void xive_native_debugfs_init(struct
kvmppc_xive *xive)
                return;
        }

-       xive->dentry = debugfs_create_file(name, 0444, arch_debugfs_dir,
+       xive->dentry = debugfs_create_file(name, 0444,
xive->kvm->debugfs_dentry,
                                           xive, &xive_native_debug_fops);


it looks fine, this is "before":

root@zz1:/sys/kernel/debug# find -iname "*xive*"
./slab/xive-provision
./powerpc/kvm-xive-c0000000208c0000
./powerpc/xive


and this is "after" the patch applied.

root@zz1:/sys/kernel/debug# find -iname "*xive*"
./kvm/29058-11/kvm-xive-c0000000208c0000
./slab/xive-provision
./powerpc/xive


I'll repost unless there is something more to it. Thanks,


-- 
Alexey
