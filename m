Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F275E44DF8B
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Nov 2021 02:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhKLBIX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Nov 2021 20:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKLBIV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Nov 2021 20:08:21 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F212C061767
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Nov 2021 17:05:32 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id n85so7030311pfd.10
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Nov 2021 17:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qIP3115D8X5svI1diQgiEcs//yqAqweVaUHfcv0HJnk=;
        b=gf554YHamci0DjUeVoZGJM9DOyXF+0SyUupZIF5IPY2cI9p2DatJ2USEjqu0xXifqV
         edjai3eTEtZQ8kQGbZs7d7Z7C15ddHZCGcYL3l3HeGlZRfffhdcwYAuRyJSd5gETgxWT
         yLNteK8tM4CfxpX7aPSWrcYkn7XhezHyrLOvS/D7LuUOUaU64FC3UuIcMReDTB79mTES
         QgRrs4WD82tMKsnnw7WDZ1CrEmW96jd/E14dYVs3INUpTy+GkkmVW2cT4+YCL5cjsCPL
         +tIV730AkW1ZKhOoB0H06e8044D6Lc1J08cwloc48Jw1uNWmresmiA1nxkB4w8of5HB5
         mVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qIP3115D8X5svI1diQgiEcs//yqAqweVaUHfcv0HJnk=;
        b=bQ41qFeC9Z4q3n2ApQuPJ8c/f8k0GePfYrA2W/+tZM0oTxgu6gUAOuEA7UKP5OBXc1
         BggBbO3lC9NsHust5YOCN8cpwzn/6BeJywbVAP2MD4WNWXCvtzVOrIsToKZXN+uhArK1
         i0qHNRrUIzKBN7oVn0oGxCQn581ptio/F8QdLR65VMbKC3GyTvDzimlrxyqxTrxqri1P
         5/mKDHjmHDcX9moHsvOmOUkfsJdSQ/fQRxKWGeEM4uBOKFHrSvTaypUNNPBD0VxZqC9N
         39hNEl0CazEAbipfoLFFylkFhgtpM0dgXKv5P/L8p3PMwRaQYRyufTLpWsAclVyCzNcc
         aAzw==
X-Gm-Message-State: AOAM533r7HgFcwD4Fpt+pZsoT14d0Vjn+AQUQcEc8JBUweRDHMU/zSmN
        euXO/vcc2wu6aA0iC2iFsaq0KA==
X-Google-Smtp-Source: ABdhPJx45D4HU2DqXINd3JCy7/gtFEnfRNSJTdzRC106LwgioqW5s9+ZH9bnEHC0LBIDe1RslUxzZw==
X-Received: by 2002:a63:8048:: with SMTP id j69mr7469829pgd.111.1636679131571;
        Thu, 11 Nov 2021 17:05:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b9sm3251946pgf.15.2021.11.11.17.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 17:05:30 -0800 (PST)
Date:   Fri, 12 Nov 2021 01:05:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5.5 24/30] KVM: Use interval tree to do fast hva lookup
 in memslots
Message-ID: <YY2919Td8f+F4EDr@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-25-seanjc@google.com>
 <d76707b5-8710-b1a6-0cc6-defdaf9e37b7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d76707b5-8710-b1a6-0cc6-defdaf9e37b7@oracle.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Nov 12, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > @@ -1262,22 +1274,32 @@ static void kvm_replace_memslot(struct kvm_memslots *slots,
> >   				struct kvm_memory_slot *new)
> >   {
> >   	/*
> > -	 * Remove the old memslot from the hash list, copying the node data
> > -	 * would corrupt the list.
> > +	 * Remove the old memslot from the hash list and interval tree, copying
> > +	 * the node data would corrupt the structures.
> >   	 */
> >   	if (old) {
> >   		hash_del(&old->id_node);
> > +		interval_tree_remove(&old->hva_node, &slots->hva_tree);
> >   		if (!new)
> >   			return;
> >   	}
> > -	/* Copy the source *data*, not the pointer, to the destination. */
> > -	if (old)
> > +	/*
> > +	 * Copy the source *data*, not the pointer, to the destination.  If
> > +	 * @old is NULL, initialize @new's hva range.
> > +	 */
> > +	if (old) {
> >   		*new = *old;
> > +	} else if (new) {
> 
> Unnecessary check - if "new" is NULL then the code will crash anyway
> accessing this pointer unconditionally...
> 
> > +		new->hva_node.start = new->userspace_addr;
> > +		new->hva_node.last = new->userspace_addr +
> > +				     (new->npages << PAGE_SHIFT) - 1;
> > +	}
> >   	/* (Re)Add the new memslot. */
> >   	hash_add(slots->id_hash, &new->id_node, new->id);
> > +	interval_tree_insert(&new->hva_node, &slots->hva_tree);
> 
> ...in these two lines above.

Yep, definitely worthless.  I think this was another "plan for the future" idea
that didn't actually add value.
