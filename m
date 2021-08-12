Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC9E3EA841
	for <lists+kvm-ppc@lfdr.de>; Thu, 12 Aug 2021 18:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhHLQIn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 12 Aug 2021 12:08:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229728AbhHLQIn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 12 Aug 2021 12:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628784497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NC2grUc+9VigyJodqV99VTSbnwgVEyRzZ6GRs3RHECQ=;
        b=Nm8UCcDvpHc1R7T2BV6kU3Y9YZWomNxST5lZR72g/NtQR3OHxgXJK4EVJDQWNGxbkBqQAh
        TxirhrC8mzLt20Z4NBGQRKqkpM3wecISZvSUVyKZWHH1pzw9BdudBJBDNQ23C9XBChWZhQ
        PI0HdH52asksmlWb/BCBLUOv//KxI1U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-7wMQ8xI3OnmmPCTQothnDg-1; Thu, 12 Aug 2021 12:08:16 -0400
X-MC-Unique: 7wMQ8xI3OnmmPCTQothnDg-1
Received: by mail-ed1-f72.google.com with SMTP id g3-20020a0564024243b02903be33db5ae6so3279316edb.18
        for <kvm-ppc@vger.kernel.org>; Thu, 12 Aug 2021 09:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NC2grUc+9VigyJodqV99VTSbnwgVEyRzZ6GRs3RHECQ=;
        b=LeQs89QIXmR1IUkHJUDvScUi0RgFf/Ui3d0mDZowqiMIZOtcTs6x1XaRVfwLARAp/7
         sDexzv/9LkCw6HEWMahqb1/Y2POqyPTZcA9bI4pzc+LZ7Ns3mKWesLH+VQwI06ckSECR
         f+RT06d8ikMYpE2tt6RD2s8/kntWIto7oODh9ASkITBd/tWE7C1az3OWzD3aUxOEka2H
         +yY6JCmVSGwAg6LV7GaVG93V31zBgJtn6a9GX2icfMS+ntECQckrcHVZdgopTUpzrVKo
         SerdwmUjYng7s/roqME9Jqo4dZP2dPdHuCNKSd8JwKm4LiypiOlD75n9/ai5BJXorN1/
         GkLg==
X-Gm-Message-State: AOAM531qCOJ2cU8ZjptX4G/bUmEgTQ55YYqan/6IMZyjtMB9Fz+OchDX
        xZI+owgtsceQnHJb3bAV3sAibmzefqu89ertEmVxc+9csw7CXFTBcb/p3aPvfsL9JJZLILN5VYH
        lGxSw6axh6+mfMIMRIQ==
X-Received: by 2002:a17:906:268b:: with SMTP id t11mr4302637ejc.397.1628784494934;
        Thu, 12 Aug 2021 09:08:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjz81j497np4AqnhzyQa+PN7vTdq0qY+6XrMtspj32CP1R8ZfSB503IdNFzh2rJLzAYacTDA==
X-Received: by 2002:a17:906:268b:: with SMTP id t11mr4302619ejc.397.1628784494727;
        Thu, 12 Aug 2021 09:08:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h8sm983608ejj.22.2021.08.12.09.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 09:08:12 -0700 (PDT)
Subject: Re: [PATCH v1] KVM: stats: Add VM stat for the cumulative number of
 dirtied pages
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
References: <20210811233744.1450962-1-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6296f7ac-bf99-2198-5a02-9d1ad721cbd3@redhat.com>
Date:   Thu, 12 Aug 2021 18:08:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210811233744.1450962-1-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 12/08/21 01:37, Jing Zhang wrote:
> A per VM stat dirty_pages is added to record the number of dirtied pages
> in the life cycle of a VM.
> The growth rate of this stat is a good indicator during the process of
> live migrations. The exact number of dirty pages at the moment doesn't
> matter. That's why we define dirty_pages as a cumulative counter instead
> of an instantaneous one.

Why not make it a per-CPU stat?  mark_page_dirty_in_slot can use 
kvm_get_running_vcpu() and skip the logging in the rare case it's NULL.

Paolo

