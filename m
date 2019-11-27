Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE9A10B5C9
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Nov 2019 19:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfK0Scm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Nov 2019 13:32:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727149AbfK0Sck (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Nov 2019 13:32:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574879559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=29WF8SRJu7k6XWM0r8jhKtWhn/ROnuR/yAPRr+2SCjM=;
        b=Fx3aIGgGCQbw2Y98VR/pvdHZGOsQC/5YgfATEVtwrcg3FkkHEOB+WlZLC+OlhjGt5Qgqz2
        RZzkrT8On4WbuTNJiv8IO4hrURdx3WxgpfIMo4YqDFNo9x3wVNyrc/0JVC5RZK2tkzy1qR
        kdCcXzQZx8W8YrpJS+pJw6XoaSF/0BE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-D5yRoFg0OQKi4cOJVtELsA-1; Wed, 27 Nov 2019 13:32:35 -0500
X-MC-Unique: D5yRoFg0OQKi4cOJVtELsA-1
Received: by mail-wr1-f69.google.com with SMTP id m17so12519050wrb.20
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Nov 2019 10:32:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=YxaL1ZT1aGySKkKsMe8gcQSf/mlZomA5ztZxEiMxVxw=;
        b=INgq5dXrpR5bjcpGN6DzZi6nBgQhfJZv54t97m6rRjD+5pbV+AWsveS12JAXk/2h06
         mup4m9E0xGIRIoNk2iCrwTYp2Bn9isG0icG/ks9eMFpNiT7PURWPAaOa/KXkeUX9lJwZ
         qE0cblIm9BaoVB1n9Nl2NJXeTdnIn6xRfc2yCNaqZse1y3q6Mo3ME1DBWMgVjUKRoCbX
         365As9gDgJs8kQC/qYUMdkr8VGRRJDJ/pk+BkWFblLUyKvkXdWLsHQDUXGW9VIIIM9LN
         HQv2WYpPOTD0a330zPHA1ibpzi84cCjnHA9TfgmH3Ijt0xf2iB3qowtgHGD8ZYudg4Ne
         AT0A==
X-Gm-Message-State: APjAAAXJgE+Q7CLH2zbPKn6THpxVEEQ19RCIcSMLS9DzhbJFGSiMJH82
        DH0LGYVxgwePV+iPzKCAbVIyqYk79AA9fHWFSCmv0HWsoxzugfwfoHmkl9CHABN5+WMJ9nDHBA8
        j/WHvgLM45yRzbHvKjw==
X-Received: by 2002:adf:ffc5:: with SMTP id x5mr3907196wrs.92.1574879554649;
        Wed, 27 Nov 2019 10:32:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8ika2gcHJ74dgNr0WfljAWH/C85tD9jVcLcwqgkOP5zVcGmWunqYNXZFhQ43XFqfbSu8vdA==
X-Received: by 2002:adf:ffc5:: with SMTP id x5mr3907176wrs.92.1574879554355;
        Wed, 27 Nov 2019 10:32:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:459f:99a9:39f1:65ba? ([2001:b07:6468:f312:459f:99a9:39f1:65ba])
        by smtp.gmail.com with ESMTPSA id o133sm8067506wmb.4.2019.11.27.10.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 10:32:33 -0800 (PST)
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
To:     Leonardo Bras <leonardo@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
 <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
 <20191126171416.GA22233@linux.intel.com>
 <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
 <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
 <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
Date:   Wed, 27 Nov 2019 19:32:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ffsTa9Xe2Ee0ZdRuXdoWLUmRFeQM2p1Zu"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ffsTa9Xe2Ee0ZdRuXdoWLUmRFeQM2p1Zu
Content-Type: multipart/mixed; boundary="aqZUHOq3nlK4WoWx9AL9jxCe3XQdlu06R"

--aqZUHOq3nlK4WoWx9AL9jxCe3XQdlu06R
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 27/11/19 19:24, Leonardo Bras wrote:
> By what I could undestand up to now, these functions that use borrowed
> references can only be called while the reference (file descriptor)
> exists.=20
> So, suppose these threads, where:
> - T1 uses a borrowed reference, and=20
> - T2 is releasing the reference (close, release):

Nit: T2 is releasing the *last* reference (as implied by your reference
to close/release).

>=20
> T1=09=09=09=09| T2
> kvm_get_kvm()=09=09=09|
> ...=09=09=09=09| kvm_put_kvm()
> kvm_put_kvm_no_destroy()=09|
>=20
> The above would not trigger a use-after-free bug, but will cause a
> memory leak. Is my above understanding right?

Yes, this is correct.

Paolo


--aqZUHOq3nlK4WoWx9AL9jxCe3XQdlu06R--

--ffsTa9Xe2Ee0ZdRuXdoWLUmRFeQM2p1Zu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl3ewUAACgkQv/vSX3jH
roNHAwf/V5jw3UuEAUr+qwFRt1WbZT7kDY6RcpqwfR7drS3cV9JoPkLaa/vuvUnj
TvZG7Q2ZVR0m2JALj914WOuC5pmAYy8HVawrFbooQ4T5mtc2akQzVD0eshLankPo
RZjfY2ijPzfY+tajHzQJ09U9Rzc33YvOZGmao/zV8/QXtFQokF1549ZJQyZPTVM0
cgiRO5mVfl0/IbchPvczCrgXIT0P4Ca9w+BN7xn1+HFGO8rvUtwaG5ZxVhUfk58B
LArJb8NkIGNDdoh3DF27nHNXak0C95hD1ENiPKVK6RrEkr/wJc6ffOS8eAdUu5yl
WmgTspYVIA7RjqLbTwLXHOQwKrvG7A==
=Shjy
-----END PGP SIGNATURE-----

--ffsTa9Xe2Ee0ZdRuXdoWLUmRFeQM2p1Zu--

