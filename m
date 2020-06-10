Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9571F5E62
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Jun 2020 00:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgFJWem (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Jun 2020 18:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgFJWek (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Jun 2020 18:34:40 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D110C08C5C1
        for <kvm-ppc@vger.kernel.org>; Wed, 10 Jun 2020 15:34:40 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id l10so2267094vsr.10
        for <kvm-ppc@vger.kernel.org>; Wed, 10 Jun 2020 15:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9LYQ8aclMkdwfJP4cdhxWD4N8cMJMuN6znPHlB3Rsc=;
        b=UevvpOtsXUfdMcqvIgRfPVVQSDyZs6oXq/Xnj/8uJDFNeQBZ7vzloiU32xzvK6mFCu
         cGGLwNrdnw/Q0on5lLXJlkuu8D4VI6gjZehfPhGO6t/torNaJ6NxHMQ2JuDgO8FwHc4P
         o8FP7KzD9QWU8u7G49I5aLDbEK8X8zhTnPGPK+25pdCKJLn9W7w1iBlkb84D2LADSGpc
         tCqhhzfq26VpCG0se8b1WZwp4CCFSusJSn+larn2+KMSi4aCsCQRQ/S3A4qsfTfUDCpT
         JYfiX91/2CIDQozv8ZBX3SClrislUPBF+zqSWJE7quvH7sEsU2MJoNuxaq5T13FcVb0X
         ExAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9LYQ8aclMkdwfJP4cdhxWD4N8cMJMuN6znPHlB3Rsc=;
        b=Ami1Aq3/y37GVK7OEIX/wzqSK+hXwa72idIlpEdzszBkJ33ulTPFSJJkIIdRCMimSD
         ThLAn5lMUOQuDjsPyL3EFVghUtQQDSmfr6STiC3HN4dpgWqc1xMKLh7xtnj+9zs0DHs3
         iYiSUWSD9KWAIKL57/3YXQnpmi+5ynqOEhQTSBYLOQuhyLIHvh3Dy8SNtNmg7exT0FCb
         JhVimDavcYEm0PfWDr2/TYuQZ4MZotlUhimlMkZDKNu5CR7RmMrtvv//rLfw74gFJpLs
         LFXyBzqDe1LF1+yWiJb6B1AHEZWxk+y25mTDJ40/RPzGtVo6cStCa7sjHd0o1iKogJ1/
         UJvQ==
X-Gm-Message-State: AOAM532L4Lu58LffwPC8Pff63Ki5k9qIGZ3kUD5oOGQ2UkU0LlpJXkkD
        zKpcYd/yJWBHKzLyHdVCuPdnQnbc0UFmlLa8la1eWQ==
X-Google-Smtp-Source: ABdhPJzdt1t5lYhNZNFDbxTCIee/fOpBW2dvkZTK5r9pH/LqHC+MVWmHSuu/UxjSaFUQydIW/izqWRJz+CsXZPttueA=
X-Received: by 2002:a67:79ce:: with SMTP id u197mr4725019vsc.17.1591828478904;
 Wed, 10 Jun 2020 15:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-8-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-8-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Jun 2020 15:34:28 -0700
Message-ID: <CANgfPd9UH01vO1SYJ3vrKq4H_DXcJ3OL_VaeY2TV8_ZH9cR1GQ@mail.gmail.com>
Subject: Re: [PATCH 07/21] KVM: x86/mmu: Topup memory caches after walking GVA->GPA
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Topup memory caches after walking the GVA->GPA translation during a
> shadow page fault, there is no need to ensure the caches are full when
> walking the GVA.  As of commit f5a1e9f89504f ("KVM: MMU: remove call
> to kvm_mmu_pte_write from walk_addr"), the FNAME(walk_addr) flow no
> longer add rmaps via kvm_mmu_pte_write().
>
> This avoids allocating memory in the case that the GVA is unmapped in
> the guest, and also provides a paper trail of why/when the memory caches
> need to be filled.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 38c576495048..3de32122f601 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -791,10 +791,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>
>         pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
>
> -       r = mmu_topup_memory_caches(vcpu);
> -       if (r)
> -               return r;
> -
>         /*
>          * If PFEC.RSVD is set, this is a shadow page fault.
>          * The bit needs to be cleared before walking guest page tables.
> @@ -822,6 +818,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>                 return RET_PF_EMULATE;
>         }
>
> +       r = mmu_topup_memory_caches(vcpu);
> +       if (r)
> +               return r;
> +
>         vcpu->arch.write_fault_to_shadow_pgtable = false;
>
>         is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
> --
> 2.26.0
>
