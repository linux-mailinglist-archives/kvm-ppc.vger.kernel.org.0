Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0B4155BEF
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Feb 2020 17:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgBGQhu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 7 Feb 2020 11:37:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58062 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726901AbgBGQhu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 7 Feb 2020 11:37:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581093469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cgH9xO+cWS+9pXG73bIgnka4EVIZlSpUaEw9L/nO7Zs=;
        b=hEAtSIioFGgHJvdkbEDbWeaMarmKlM7ktRYcrUETOuZK2TGk7XkRj1qzEnBHU0GTg/OcbM
        m2f7pRKITJApBPMyRyn/QmceRRsiHeZiEQw/Obg2iO2cs9B6EHIanGJd2meTtVGdCWhl6Z
        T8VbJ2aiSeSfpLqv29ZaccmxmgiffbI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-OW3YrUKNPIKSmoY6NAh-pg-1; Fri, 07 Feb 2020 11:37:45 -0500
X-MC-Unique: OW3YrUKNPIKSmoY6NAh-pg-1
Received: by mail-qk1-f199.google.com with SMTP id s9so1771498qkg.21
        for <kvm-ppc@vger.kernel.org>; Fri, 07 Feb 2020 08:37:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cgH9xO+cWS+9pXG73bIgnka4EVIZlSpUaEw9L/nO7Zs=;
        b=VBvqOfGZW6VC5fTq28aoAlHQjfF0I4oDLjhe7WB1ARhZZO1GSoBb14RrTvcXtMEVZ+
         rCsg4oFkvWj3ZlypGxAXHvHceB3fHuSEm70/JFx7f9RrzuvoK5NhwAWqB8CHztlbmPTm
         qvD3XDpkGYI024FjK7f7oMm70LPur5Iufo+kV5r6YUt6wg92FQ00+x795CJWAt4FgyyQ
         JbXm521x8HG9WxQKJJcZMBlScsK+PPFoqLJZinBjzYNGYKtSWcEI4QFXg5FlRx8BgOGW
         alfy2g78LQt+mlNl+fCBduur8mGsYBkvCzk+SjejOTT/HI25X4hDFgz4TQFlO3/roBJw
         7WGA==
X-Gm-Message-State: APjAAAXMLabiNbX3cWM5k6EWBSI/LWNUlhSa59XCgmnhrCDxpFeihAOA
        lvMPUcCRpcb9Rs5tg0gE/0W3uiJWBBqdpnvd55uiXDvJDgSSCE3hsbWl+/y4bOxHBgBjTo7C58L
        LZfdBTeerp0PsiHwM0w==
X-Received: by 2002:a05:6214:11ac:: with SMTP id u12mr7667065qvv.85.1581093464520;
        Fri, 07 Feb 2020 08:37:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqyADx3loVUdRKb44G4UQsDsAdknpBOKbHmW0fDqmSZoyg4OJXL3ZNHkOudrrNbkAu5Phy9RLA==
X-Received: by 2002:a05:6214:11ac:: with SMTP id u12mr7667045qvv.85.1581093464263;
        Fri, 07 Feb 2020 08:37:44 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id 124sm1548666qko.11.2020.02.07.08.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 08:37:43 -0800 (PST)
Date:   Fri, 7 Feb 2020 11:37:40 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20200207163740.GA720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
 <20200206221208.GI700495@xz-x1>
 <20200207153829.GA2401@linux.intel.com>
 <20200207160546.GA707371@xz-x1>
 <20200207161553.GE2401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200207161553.GE2401@linux.intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Feb 07, 2020 at 08:15:53AM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2020 at 11:05:46AM -0500, Peter Xu wrote:
> > On Fri, Feb 07, 2020 at 07:38:29AM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 06, 2020 at 05:12:08PM -0500, Peter Xu wrote:
> > > > This patch is tested so I believe this works, however normally I need
> > > > to do similar thing with [0] otherwise gcc might complaint.  Is there
> > > > any trick behind to make this work?  Or is that because of different
> > > > gcc versions?
> > > 
> > > array[] and array[0] have the same net affect, but array[] is given special
> > > treatment by gcc to provide extra sanity checks, e.g. requires the field to
> > > be the end of the struct.  Last I checked, gcc also doesn't allow array[]
> > > in unions.  There are probably other restrictions.
> > > 
> > > But, it's precisely because of those restrictions that using array[] is
> > > preferred, as it provides extra protections, e.g. if someone moved memslots
> > > to the top of the struct it would fail to compile.
> > 
> > However...
> > 
> > xz-x1:tmp $ cat a.c
> > struct a {
> >     int s[];
> > };
> > 
> > int main(void) { }
> > xz-x1:tmp $ make a
> > cc     a.c   -o a
> > a.c:2:9: error: flexible array member in a struct with no named members
>                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> gcc is telling you quite explicitly why it's angry.  Copy+paste from the
> internet[*]:
> 
>   Flexible Array Member(FAM) is a feature introduced in the C99 standard of the
>   C programming language.
> 
>   For the structures in C programming language from C99 standard onwards, we
>   can declare an array without a dimension and whose size is flexible in nature.
> 
>   Such an array inside the structure should preferably be declared as the last 
>   member of structure and its size is variable(can be changed be at runtime).
>   
>   The structure must contain at least one more named member in addition to the
>   flexible array member. 
> 
> [*] https://www.geeksforgeeks.org/flexible-array-members-structure-c/

Sorry again for not being able to identify the meaning of that
sentence myself.  My English is probably even worse than I thought...

So I think my r-b keeps.

Thanks,

-- 
Peter Xu

