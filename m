Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA6210B39F
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Nov 2019 17:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfK0QlC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Nov 2019 11:41:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbfK0QlC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Nov 2019 11:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574872860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9clyZwt1Uy0kISk+R89yEnPo3r3EiKdUvG2fY8pwo4=;
        b=RYNPwvFkBx/OMwUvtxVAC1LZ3pNhGnOV4au36/Sh0D644XgKsG0H9DLSm/jKzhZUFV736x
        wR7bLgEkaaE2hsmWuN/V5uKkQX7DPObSe0dNasBkSI/O9k67szGAacj53B7ym9kVJrVvg0
        lEDqbIakJkKzd54yGf//ghIJkLUsqEI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-oRoz_QkZMH6qleeoilAhfA-1; Wed, 27 Nov 2019 11:40:57 -0500
Received: by mail-wm1-f71.google.com with SMTP id s25so1943889wmj.3
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Nov 2019 08:40:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D9clyZwt1Uy0kISk+R89yEnPo3r3EiKdUvG2fY8pwo4=;
        b=PjROBNTgICFRab42KFaRj5FYV8Txa5ayqJvOwubDBTGymg3ut1Vef9fh6/ltsUkJpM
         aW6aySfiL2olS9A72srUI/dyDyMny15zEX7lRmfWXSJ9qko5DW+dJMxmi1kqSnhgc8zj
         axZFm4msPXz+txoa09hNHrWE7ERU1Q/qTysg498SkyUqNunh+yXuGYTjB/4nUAghPeVW
         oPbP45Q3UXiFDHPRsCqL1hMR/BM/vcVb/07DZnwz3dssOKtNcr+sA717XfrJmNQIkeXx
         OAX5oCcQIiS6hcco23wGQ4aaMJzIsxiYCVumYDnPgL8AMLAjMU7uP5XXPo4VTv+Tngyr
         v2kQ==
X-Gm-Message-State: APjAAAUJyvq6bvBVs7j9fL77iZj2pzB9r3ONw4Q/k8sWguaDjnVIlwYj
        jf3QJULWC5xFUQdRl3EO4hERCg3QgMq0lH/Mbx4AbCzpaW+k1uqX2NjD70yPNW3ioq3C2exCTEv
        HivtXuJz7m1DSvgyhvg==
X-Received: by 2002:a5d:6548:: with SMTP id z8mr46445807wrv.273.1574872856521;
        Wed, 27 Nov 2019 08:40:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwJQYQNL5K2QbppXpn6b5gcGOLuYeQF7OCPZVcjBL74U3Lx1Ff4ldEAiNEf3QLlek78dqhKpg==
X-Received: by 2002:a5d:6548:: with SMTP id z8mr46445770wrv.273.1574872856109;
        Wed, 27 Nov 2019 08:40:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:459f:99a9:39f1:65ba? ([2001:b07:6468:f312:459f:99a9:39f1:65ba])
        by smtp.gmail.com with ESMTPSA id b63sm6832818wmb.40.2019.11.27.08.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 08:40:55 -0800 (PST)
Subject: Re: [PATCH 1/1] powerpc/kvm/book3s: Fixes possible 'use after
 release' of kvm
To:     Leonardo Bras <leonardo@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20191126175212.377171-1-leonardo@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f3750cf8-88fc-cae7-1cfb-cb4b86b44704@redhat.com>
Date:   Wed, 27 Nov 2019 17:40:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191126175212.377171-1-leonardo@linux.ibm.com>
Content-Language: en-US
X-MC-Unique: oRoz_QkZMH6qleeoilAhfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 26/11/19 18:52, Leonardo Bras wrote:
> Fixes a possible 'use after free' of kvm variable.
> It does use mutex_unlock(&kvm->lock) after possible freeing a variable
> with kvm_put_kvm(kvm).
> 
> Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_64_vio.c | 3 +--
>  virt/kvm/kvm_main.c              | 8 ++++----
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index 5834db0a54c6..a402ead833b6 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -316,14 +316,13 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  
>  	if (ret >= 0)
>  		list_add_rcu(&stt->list, &kvm->arch.spapr_tce_tables);
> -	else
> -		kvm_put_kvm(kvm);
>  
>  	mutex_unlock(&kvm->lock);
>  
>  	if (ret >= 0)
>  		return ret;
>  
> +	kvm_put_kvm(kvm);
>  	kfree(stt);
>   fail_acct:
>  	account_locked_vm(current->mm, kvmppc_stt_pages(npages), false);

This part is a good change, as it makes the code clearer.  The
virt/kvm/kvm_main.c bits, however, are not necessary as explained by Sean.

Paolo

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13efc291b1c7..f37089b60d09 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2744,10 +2744,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	/* Now it's all set up, let userspace reach it */
>  	kvm_get_kvm(kvm);
>  	r = create_vcpu_fd(vcpu);
> -	if (r < 0) {
> -		kvm_put_kvm(kvm);
> +	if (r < 0)
>  		goto unlock_vcpu_destroy;
> -	}
>  
>  	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
>  
> @@ -2771,6 +2769,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	mutex_lock(&kvm->lock);
>  	kvm->created_vcpus--;
>  	mutex_unlock(&kvm->lock);
> +	if (r < 0)
> +		kvm_put_kvm(kvm);
>  	return r;
>  }
>  
> @@ -3183,10 +3183,10 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>  	kvm_get_kvm(kvm);
>  	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
>  	if (ret < 0) {
> -		kvm_put_kvm(kvm);
>  		mutex_lock(&kvm->lock);
>  		list_del(&dev->vm_node);
>  		mutex_unlock(&kvm->lock);
> +		kvm_put_kvm(kvm);
>  		ops->destroy(dev);
>  		return ret;
>  	}
> 

