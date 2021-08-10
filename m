Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2693E863F
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 00:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhHJW45 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 10 Aug 2021 18:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbhHJW44 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 10 Aug 2021 18:56:56 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC32C061765
        for <kvm-ppc@vger.kernel.org>; Tue, 10 Aug 2021 15:56:33 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id x7so1181300ljn.10
        for <kvm-ppc@vger.kernel.org>; Tue, 10 Aug 2021 15:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0guZGh3UnDt1Ync+oDjYNyn07OmVz96vW3SUASWQ3Y=;
        b=gkgNcZBayT9URJNgooJT3u52M8EJuh0u8RouQHgcEsqk0j6757Mp146ug6zKXZ76vc
         kPrDMYpsq/9JwZ4Kz73IC9casVvCtGulTE4n8s33UnfZiWdf01OTw/ql81H/rDptr657
         rCSvhC+iehD5wk5jInyYZqSrVr8LHO1qAMVYGKbLP/EgtqBp2DPNE6RyTYJJzmpwn27/
         /Sk+YBMD0uysIHynePlyCAQxQnIlZRq67+Q/fJ/1IgzCyeY0+mZWyyhBUZ0CiwRRM/Ps
         5Fvk2TY1ioXnQOeqqFf5pZjShwWkTiuFrCp9EY0aNkhLMZj++I5z5J0IxQrKoRCVun2V
         XhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0guZGh3UnDt1Ync+oDjYNyn07OmVz96vW3SUASWQ3Y=;
        b=ORJSCRpF9DsvDTWXvgshI9GVIvmeWL8+UNCIW4DHRlRFj/n+oFrtSB6OpdyygsCgT/
         7hpe/p1F//RMSNXmMy8l4pWV89MVg4rDlzeVFQxrTSdKj/bq7A/uftwUA9o9Lc7E0Ao0
         oTPP47Ik9V+bGmYMeY3Dg2WytMP7cPExo+mQlwii8m3/NTk8n/zNXwyd4ck27RBw6wgF
         PYoqLEG/c8dBz1wQn+N8Mu7dM9TC64USLPU0E2eiymqkx+H7pHOgyNV/aHN2KnJP+bXV
         uqC2lFaNhU+glwJ2ZskG/o3iuymKg5qS8l1WBJL3Uzw6SJJVnTQ5WcAGUv2UyG1gO4vD
         /akw==
X-Gm-Message-State: AOAM530nz3Bt+3qprC5g7e/PQV+utDQuUJnL6P+dfagvMNlm9bGwCf90
        LwtbXOA5tshQMtJjfKKb5YYS/YBcLUiq3LWpu3yW9g==
X-Google-Smtp-Source: ABdhPJy71R1+NnNfVQhRQf4aCg+eUQslCabG5l/ZpXACcJN4BkepfXiRq7YIMM5en8bEG64fSLAnXLZCrQswRzuL/sA=
X-Received: by 2002:a2e:89c4:: with SMTP id c4mr20686726ljk.275.1628636191854;
 Tue, 10 Aug 2021 15:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210810223238.979194-1-jingzhangos@google.com>
In-Reply-To: <20210810223238.979194-1-jingzhangos@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 10 Aug 2021 15:56:20 -0700
Message-ID: <CAOQ_QshcSQWhEUt9d7OV58V=3WrL34xfpFYS-wp6H4rzy_r_4w@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of
 dirty pages
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Jing,

On Tue, Aug 10, 2021 at 3:32 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> Add a generic VM stats dirty_pages to record the number of dirty pages
> reflected in dirty_bitmap at the moment.

There can be multiple dirty bitmaps in a VM, one per memslot.

> Original-by: Peter Feiner <pfeiner@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_hv.c    |  8 ++++++--
>  arch/powerpc/kvm/book3s_64_mmu_radix.c |  1 +
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c    |  1 +
>  include/linux/kvm_host.h               |  3 ++-
>  include/linux/kvm_types.h              |  1 +
>  virt/kvm/kvm_main.c                    | 26 +++++++++++++++++++++++---
>  6 files changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index c63e263312a4..e4aafa10efa1 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -1122,8 +1122,10 @@ long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
>                  * since we always put huge-page HPTEs in the rmap chain
>                  * corresponding to their page base address.
>                  */
> -               if (npages)
> +               if (npages) {
>                         set_dirty_bits(map, i, npages);
> +                       kvm->stat.generic.dirty_pages += npages;
> +               }
>                 ++rmapp;
>         }
>         preempt_enable();
> @@ -1178,8 +1180,10 @@ void kvmppc_unpin_guest_page(struct kvm *kvm, void *va, unsigned long gpa,
>         gfn = gpa >> PAGE_SHIFT;
>         srcu_idx = srcu_read_lock(&kvm->srcu);
>         memslot = gfn_to_memslot(kvm, gfn);
> -       if (memslot && memslot->dirty_bitmap)
> +       if (memslot && memslot->dirty_bitmap) {
>                 set_bit_le(gfn - memslot->base_gfn, memslot->dirty_bitmap);
> +               ++kvm->stat.generic.dirty_pages;
> +       }
>         srcu_read_unlock(&kvm->srcu, srcu_idx);
>  }
>
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> index b5905ae4377c..3a6cb3854a44 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -1150,6 +1150,7 @@ long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
>                 j = i + 1;
>                 if (npages) {
>                         set_dirty_bits(map, i, npages);
> +                       kvm->stat.generic.dirty_pages += npages;
>                         j = i + npages;
>                 }
>         }
> diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> index 632b2545072b..16806bc473fa 100644
> --- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> +++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> @@ -109,6 +109,7 @@ void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
>         npages = (psize + PAGE_SIZE - 1) / PAGE_SIZE;
>         gfn -= memslot->base_gfn;
>         set_dirty_bits_atomic(memslot->dirty_bitmap, gfn, npages);
> +       kvm->stat.generic.dirty_pages += npages;
>  }
>  EXPORT_SYMBOL_GPL(kvmppc_update_dirty_map);
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f50bfcf225f0..1e8e66fb915b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1421,7 +1421,8 @@ struct _kvm_stats_desc {
>                 KVM_STATS_BASE_POW10, -9)
>
>  #define KVM_GENERIC_VM_STATS()                                                \
> -       STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
> +       STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),                      \
> +       STATS_DESC_COUNTER(VM_GENERIC, dirty_pages)
>
>  #define KVM_GENERIC_VCPU_STATS()                                              \
>         STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),                \
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index ed6a985c5680..6c05df00aebf 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -78,6 +78,7 @@ struct kvm_mmu_memory_cache {
>
>  struct kvm_vm_stat_generic {
>         u64 remote_tlb_flush;
> +       u64 dirty_pages;
>  };
>
>  struct kvm_vcpu_stat_generic {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a438a7a3774a..93f0ca2ea326 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1228,6 +1228,19 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
>         return 0;
>  }
>
> +static inline unsigned long hweight_dirty_bitmap(
> +                                               struct kvm_memory_slot *memslot)
> +{
> +       unsigned long i;
> +       unsigned long count = 0;
> +       unsigned long n = kvm_dirty_bitmap_bytes(memslot);
> +
> +       for (i = 0; i < n / sizeof(long); ++i)
> +               count += hweight_long(memslot->dirty_bitmap[i]);
> +
> +       return count;
> +}

Hrm, this seems like a decent amount of work for a statistic.

> +
>  /*
>   * Delete a memslot by decrementing the number of used slots and shifting all
>   * other entries in the array forward one spot.
> @@ -1612,6 +1625,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
>         if (r)
>                 return r;
>
> +       kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(old);
>         kvm_free_memslot(kvm, old);
>         return 0;
>  }
> @@ -1733,8 +1747,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
>         if (r)
>                 goto out_bitmap;
>
> -       if (old.dirty_bitmap && !new.dirty_bitmap)
> +       if (old.dirty_bitmap && !new.dirty_bitmap) {
> +               kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(&old);
>                 kvm_destroy_dirty_bitmap(&old);
> +       }

Races to increment by a few pages might be OK, so long as imprecision
is acceptable, but decrementing by an entire bitmap could cause the
stat to get waaay off from the state of the VM.

What if the statistic was 'dirtied_pages', which records the number of
pages dirtied in the lifetime of a VM? Userspace could just record the
value each time it blows away the dirty bitmaps and subtract that
value next time it reads the stat. It would circumvent the need to
walk the entire dirty bitmap to keep the statistic sane.

>         return 0;
>
>  out_bitmap:
> @@ -1895,6 +1911,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
>                         offset = i * BITS_PER_LONG;
>                         kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
>                                                                 offset, mask);
> +                       kvm->stat.generic.dirty_pages -= hweight_long(mask);
>                 }
>                 KVM_MMU_UNLOCK(kvm);
>         }
> @@ -2012,6 +2029,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>                         flush = true;
>                         kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
>                                                                 offset, mask);
> +                       kvm->stat.generic.dirty_pages -= hweight_long(mask);
>                 }
>         }
>         KVM_MMU_UNLOCK(kvm);
> @@ -3062,11 +3080,13 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>                 unsigned long rel_gfn = gfn - memslot->base_gfn;
>                 u32 slot = (memslot->as_id << 16) | memslot->id;
>
> -               if (kvm->dirty_ring_size)
> +               if (kvm->dirty_ring_size) {
>                         kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
>                                             slot, rel_gfn);
> -               else
> +               } else {
>                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
> +                       ++kvm->stat.generic.dirty_pages;
> +               }

Aren't pages being pushed out to the dirty ring just as dirty? :-)

>         }
>  }
>  EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
>
> base-commit: d0732b0f8884d9cc0eca0082bbaef043f3fef7fb
> --
> 2.32.0.605.g8dce9f2422-goog
>
