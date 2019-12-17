Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3487123A2E
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Dec 2019 23:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfLQWsI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Dec 2019 17:48:08 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57573 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726454AbfLQWsI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Dec 2019 17:48:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576622887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9n/i9QgxhO0hGtWuQAcaruEVu8v3TGl7tcrGGNBkk0M=;
        b=ALfbLL7LqVea7auuoFdfHW9NGtLpKv4xKIdEYh0ree8Aa0fVJLe3ePm3ILRzOk8Aq2p6zA
        gcZk2crU1HTFJriyovdrPjyF/PJrukvgrc6ul9Ua94GtF9qrdXjvw/fgJFTNm2OUav8vX4
        nWAW2CLheFJ+c8i7Cereh5Y/37/lbCE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-g8ebMCvtNIm4htRp2VJhwg-1; Tue, 17 Dec 2019 17:48:05 -0500
X-MC-Unique: g8ebMCvtNIm4htRp2VJhwg-1
Received: by mail-qv1-f69.google.com with SMTP id e14so166257qvr.6
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Dec 2019 14:48:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9n/i9QgxhO0hGtWuQAcaruEVu8v3TGl7tcrGGNBkk0M=;
        b=PVp/MqBZGx6AQho9x1ZMfpItRRfrSGPqnkOrIDffTJ5FxuqMORpKYfnjcm18hB/LUl
         ZZpDGReRKG8m85TerM1EnNytiTxBBRXNlyPOKwmhA38BmwGYt2uX+NtIekw+3NQJFcV2
         FJ3Fv2VWXqJe/OpIMuf6uagOTGIGEfECXrLTJKq6mzThymNyDt34XVVegjypUp9B6jfo
         v8+sU+hemjFq7FtJtb+cYkaPO86E9jMafkzoIVGc9ns9WtljRuL7aLMwhWXJ5qpJ79Dq
         24ODkfpD0O/qJ4ETASGzy1VltkzIhVjo+TjMYBVuxniARtaIfhdy2M5T0dH2LRgfMfL0
         v/sg==
X-Gm-Message-State: APjAAAV2577gkFQgIUci5JC+6WPM+M/5wQXU8reWE3DLQS1NqmI02jMu
        Jo5CSvb2dVjZbn5+DjWJoSrSl9WKepxy11fgrGFw3dIX0+zq8KLjeRRldAAFkjoryuTrJLDo4qu
        2KKv8YJYs3j+KWc1gJg==
X-Received: by 2002:a37:7685:: with SMTP id r127mr461131qkc.166.1576622885310;
        Tue, 17 Dec 2019 14:48:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzAlgi3q/A/lG8/yssi/9qke3Y+PomWjoA6OIsiWSdyH+oKnvcw0q0J4LOd+HEQncOFra+UA==
X-Received: by 2002:a37:7685:: with SMTP id r127mr461111qkc.166.1576622885122;
        Tue, 17 Dec 2019 14:48:05 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id 63sm15645qki.57.2019.12.17.14.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:48:04 -0800 (PST)
Date:   Tue, 17 Dec 2019 17:48:02 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 11/19] KVM: x86: Free arrays for old memslot when
 moving memslot's base gfn
Message-ID: <20191217224802.GA26669@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-12-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191217204041.10815-12-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Dec 17, 2019 at 12:40:33PM -0800, Sean Christopherson wrote:
> Explicitly free the metadata arrays (stored in slot->arch) in the old
> memslot structure when moving the memslot's base gfn is committed.  This
> eliminates x86's dependency on kvm_free_memslot() being called when a
> memlsot move is committed, and paves the way for removing the funky code
> in kvm_free_memslot() that conditionally frees structures based on its
> @dont param.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

