Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC21C15ABB6
	for <lists+kvm-ppc@lfdr.de>; Wed, 12 Feb 2020 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgBLPIi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 12 Feb 2020 10:08:38 -0500
Received: from mail-eopbgr1320040.outbound.protection.outlook.com ([40.107.132.40]:3081
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728094AbgBLPIh (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 12 Feb 2020 10:08:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVlsmforN60bmsgarRgZjSkOaYeMvdUMUFaVdSRzcf89iNum1UoZcaLi5gPbdTluUbFBjHjrUnfhndVmETHopdWMjzd/r9VGr3OZvckGXgYpCWyRZuwd/JG/0od1GQszWteVS+WkfLSM4KBMKz9HnrfTzI9FPRW5MgUsqS6+bLHNd/N101JgnxaNkbTm2qHI/JK52Gl4/MPBcIQO9JMkkPMGmqAblEVByrgPySUxU+P8qxr2nV1UBl8+Fv26AgpnCVWAVfT7HuhJ2y5uv1O52eq0hdtgflb9Pv6+2tw03yek1RbA0AXgq7Oo78KfxrauSgWLmjhd6K4dZr006cpaAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7PxbexAZYB6GiHIsB0XVBOAyOcBFISxeBHwChZFuLo=;
 b=NXoKsyUBxVtD8Q1maU4PYSV+hxOuhN7xtJY1nSZfKUlZ97v3nhmd1SZ7WFYxLXU1vqBCw2JpLbunspdL51AhijxvVv8sYb9fooZRxP/pPVevfBzU7BHJTNIafwEf3ld3Zc8OAsPLa4kCsbsRx/KE5+NuAjseB3mq/S1VODETbeHpjkLvPIcnB+AhKgdBUDTIhN+a6dF+GPoayo6UOfl8nlUcbWcHozsrNjDZK0yKDq+RLr4cg0lG1UfcepzdRg2OHIcssKFoGrtZrSq/BUEhfjLkZHLTHAHXo0xCsgiHIbbvp4RXbMYEDut6NMYK5LMGePRVN/MFT1qV6Sjpmo0PDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=teo-en-ming-corp.com; dmarc=pass action=none
 header.from=teo-en-ming-corp.com; dkim=pass header.d=teo-en-ming-corp.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=teoenmingcorp.onmicrosoft.com; s=selector2-teoenmingcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7PxbexAZYB6GiHIsB0XVBOAyOcBFISxeBHwChZFuLo=;
 b=SQuw6dgzA1O8CqzPaH21T/aggnU5tfv9yvewRbEn1kyzx4i3g//4+GUbtyWtNgqlDUyBb+p3+DP/5317Y8zSn3ml6geraO7fo3fF1V0l/c4oGU7bCT0HlpQHmkCUQM7qLdTA1qeYWSuHaHSzg7vEyhx6RBuz93SJoY995/HicsE=
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com (10.170.143.19) by
 SG2PR01MB2838.apcprd01.prod.exchangelabs.com (20.177.170.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.27; Wed, 12 Feb 2020 15:08:34 +0000
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::684a:9e0b:7e12:18bd]) by SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::684a:9e0b:7e12:18bd%4]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 15:08:34 +0000
From:   Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
To:     "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
CC:     Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
Subject: 4K video rendering speed in Windows 10 virtual machine with GPU
 passthrough (QEMU/KVM)
Thread-Topic: 4K video rendering speed in Windows 10 virtual machine with GPU
 passthrough (QEMU/KVM)
Thread-Index: AQHV4bZAQYuFqIeCtEOGpb1Hw8WOAg==
Date:   Wed, 12 Feb 2020 15:08:34 +0000
Message-ID: <SG2PR01MB21414E6C0BE42B00E16E5627871B0@SG2PR01MB2141.apcprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ceo@teo-en-ming-corp.com; 
x-originating-ip: [2401:7400:c802:de67:ec11:5df0:48d0:242d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9e224de-bec0-4aa2-d446-08d7afcd6dd1
x-ms-traffictypediagnostic: SG2PR01MB2838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SG2PR01MB2838DD364BD2A159A5D96A7D871B0@SG2PR01MB2838.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(376002)(39830400003)(136003)(396003)(199004)(189003)(8676002)(9686003)(55016002)(6506007)(81156014)(81166006)(6916009)(186003)(8936002)(7696005)(71200400001)(2906002)(4326008)(66556008)(64756008)(66476007)(66946007)(316002)(66446008)(5660300002)(52536014)(76116006)(86362001)(107886003)(966005)(33656002)(508600001);DIR:OUT;SFP:1101;SCL:1;SRVR:SG2PR01MB2838;H:SG2PR01MB2141.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: teo-en-ming-corp.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m6HQVx8+d+Q8E7YjgxfPyHCKhXtSBCt9KNLFSeky5YEiopkloQuauJt9d2Fv2rQGdowDKftpotuQCh1AZiPFXYF1SQJG9ARq8fAkhmpTtOgAsmsNlsgj/8IVbwUNpBCFpgfOm/RXoq1Pt1EABjxyl+JELIzmuZkuZnAI4B9iSS0gdEl1it9scgyLdzPa5E0s8EcyQ14F/PuwVQLQuFJqVdFs1vIDPv+5Dlu6GEdodMJkBiIQgq8i1ruCUyZJrU0mXyCgtZ02Z3bxeUaAyTV/Emo8Eb4YSnW7xVLJBWWerAbQ8ev09yagYb+V4L03BeoRCPJ68jKsqUi+zQkmWtO6bkDlqlExIOSqbwuR8vSbGxlaiIIELEJmUo/dpHnTS4m4KYJFK0jDnN2zd1kncMxWmzvrooMoEHuHqMM6HKM9/QYnKaneksviwNTxZaSAv7k3w6kVvJ+XZECcSZ8Ovs9kV28ynSP6CsYrg9qA6UwrzRFSv1d8In5rzQWKGN5rtWM/u/ldhtvEpg8neLGrP5foPg==
x-ms-exchange-antispam-messagedata: J+OdCwmvrNIZ9gjiVWnO17JLtvM5kYPpfAGRk8s5CSjabwZf/WhqDrcX2xAAIA1zEAAgkSonGVybWagV7pra/McOyLdeXpFPKCXlPLqQVpQDX/apFS3b/UNdZbSYLPU1rn66K5j2rSUlse4UfqgIcwTDBUYyMxFLF5D41hx0ArReMhOfy1wnsz3I6mMGoYS/El5/H3y0g6R1+5xzRKcUNQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: teo-en-ming-corp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e224de-bec0-4aa2-d446-08d7afcd6dd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 15:08:34.0069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b3f6ae-c453-4b93-aec9-f17508e5885c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q3p4pHU6GgZBCps8XIVb7C3qU7A57eim4jYFbMx5xFMv6ltuVy/wjfpYnjelK7oJEzGHOFittRQSFWKYvbC6P0jjvwFFMyeP1JDfpEGU/24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR01MB2838
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

4K video rendering speed in Windows 10 virtual machine with GPU passthrough=
 (QEMU/KVM)=0A=
=0A=
Processor: AMD Ryzen 3 3200G with Radeon Vega Graphics=0A=
=0A=
Virtual CPUs: 3=0A=
=0A=
Motherboard: Gigabyte B450M DS3H BIOS version F41=0A=
=0A=
RAM: 16 GB=0A=
=0A=
GPU Passthrough: MSI GeForce GTX1650 4 GB GDDR5=0A=
=0A=
Results:=0A=
=0A=
The time taken to render a 2 hr 33 min 4K video is 4 hr 50 min (4K video re=
ndering speed).=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
-----BEGIN EMAIL SIGNATURE-----=0A=
=0A=
The Gospel for all Targeted Individuals (TIs):=0A=
=0A=
[The New York Times] Microwave Weapons Are Prime Suspect in Ills of=0A=
U.S. Embassy Workers=0A=
=0A=
Link: https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microwav=
e.html=0A=
=0A=
***************************************************************************=
*****************=0A=
=0A=
=0A=
=0A=
Singaporean Mr. Turritopsis Dohrnii Teo En Ming's Academic=0A=
Qualifications as at 14 Feb 2019 and refugee seeking attempts at the United=
 Nations Refugee Agency Bangkok (21 Mar 2017), in Taiwan (5 Aug 2019) and A=
ustralia (25 Dec 2019 to 9 Jan 2020):=0A=
=0A=
=0A=
[1] https://tdtemcerts.wordpress.com/=0A=
=0A=
[2] https://tdtemcerts.blogspot.sg/=0A=
=0A=
[3] https://www.scribd.com/user/270125049/Teo-En-Ming=0A=
=0A=
-----END EMAIL SIGNATURE-----=0A=
=0A=
=0A=
=0A=
